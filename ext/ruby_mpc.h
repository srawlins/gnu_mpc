#ifndef _RUBY_MPC_H_
#define _RUBY_MPC_H_

#include <stdio.h>
#include <ruby.h>
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <ruby_gmp.h>
#include <mpc.h>

#include <stdlib.h>

/*
 * (a comment borrowed from the Ruby GMP bindings:)
 * MP_???* is used because they don't have side-effects of single-element arrays mpc_t
 */
typedef __mpc_struct MP_COMPLEX;

#define mpc_get_struct(ruby_var,c_var) { Data_Get_Struct(ruby_var, MP_COMPLEX, c_var); }
#define mpc_make_struct(ruby_var,c_var) { ruby_var = Data_Make_Struct(cMPC, MP_COMPLEX, 0, r_mpc_free, c_var); }
#define mpc_make_struct_init(ruby_var,c_var) { mpc_make_struct(ruby_var,c_var); mpc_init (c_var); }
#define mpc_make_struct_init3(ruby_var,c_var,real_prec,imag_prec) { mpc_make_struct(ruby_var,c_var); mpc_init3 (c_var, real_prec, imag_prec); }
#define MPC_P(value) (rb_obj_is_instance_of(value,cMPC) == Qtrue)
#define mpc_set_bignum(var_mpc,var_bignum) {                         \
    VALUE tmp = rb_funcall (                                         \
        rb_funcall (var_bignum, rb_intern ("to_s"), 1, INT2FIX(32)), \
        rb_intern("upcase"),                                         \
        0);                                                          \
    mpc_set_str (var_mpc, StringValuePtr (tmp), 32);                 \
}

#define mpc_temp_alloc(var) { var=malloc(sizeof(MP_COMPLEX)); }
#define mpc_temp_init(var,prec) { mpc_temp_alloc(var); mpc_init2(var,prec); }
#define mpc_temp_free(var) { mpc_clear(var); free(var); }

#define r_mpc_set_z(var1, var2) (mpc_set_z (var1, var2, __gmp_default_rounding_mode))
#define r_mpc_set_d(var1, var2) (mpc_set_d (var1, var2, __gmp_default_rounding_mode))

/* EXPECTED_Cxxx macros */
#define EXPECTED_FXC "Expected GMP::F, Fixnum, or MPC"

// MPC Rounding Modes
#define mpcrnd_get_struct(ruby_var,c_var) { Data_Get_Struct(ruby_var, int, c_var); }
#define mpcrnd_make_struct(ruby_var,c_var) { ruby_var = Data_Make_Struct(cMPC_Rnd, int, 0, 0, c_var); }
#define MPCRND_P(value) (rb_obj_is_instance_of(value, cMPC_Rnd) == Qtrue)
#define r_mpc_default_rounding_mode MPC_RNDNN

extern VALUE cMPC;
extern VALUE cMPC_Rnd;

extern void mpc_set_value(MP_COMPLEX *target, VALUE source, mpc_rnd_t rnd);
extern VALUE r_mpc_eq(VALUE self, VALUE arg);
extern VALUE r_mpc_cmp(VALUE self, VALUE arg);
extern int mpc_cmp_value(MP_COMPLEX *OP, VALUE arg);

extern void r_mpc_free(void *ptr);
extern mpc_rnd_t r_get_mpc_rounding_mode(VALUE rnd);
extern mpc_rnd_t r_get_default_mpc_rounding_mode();
extern mpc_rnd_t r_mpc_get_rounding_mode(VALUE rnd);
extern void init_mpcrnd();

#endif /* _RUBY_MPC_H_ */
