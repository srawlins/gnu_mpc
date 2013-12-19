#include <ruby_mpc.h>

/**********************************************************************
 *    MPC Random Numbers                                              *
 **********************************************************************/

/*
 * call-seq:
 *   rand_state.mpc_urandom()
 *
 * From the MPC Manual:
 *
 * Generate a uniformly distributed random complex in the unit square [0,1] x [0,1].
 */
VALUE r_gmprandstate_mpc_urandom(int argc, VALUE *argv, VALUE self_val)
{
  MP_RANDSTATE *self;
  MP_COMPLEX *res;
  VALUE res_val;
  unsigned long prec = 0;

  if (argc > 1)
    rb_raise (rb_eArgError, "wrong # of arguments (%d for 0 or 1)", argc);

  mprandstate_get_struct (self_val, self);

  if (argc == 1) {
    if (FIXNUM_P (argv[0])) {
      if (FIX2INT (argv[0]) >= 2)
        prec = FIX2INT (argv[0]);
      else
        rb_raise (rb_eRangeError, "prec must be at least 2");
    } else {
      rb_raise (rb_eTypeError, "prec must be a Fixnum");
    }
  }

  mpc_make_struct (res_val, res);
  if (prec == 0) { mpc_init2 (res, mpfr_get_default_prec()); }
  else           { mpc_init2 (res, prec); }

  mpc_urandom (res, self);

  return res_val;
}

void init_gmprandstate_mpc()
{
  mGMP = rb_define_module("GMP");
  cGMP_RandState = rb_define_class_under(mGMP, "RandState", rb_cObject);

  // Complex Random Numbers
  rb_define_method(cGMP_RandState, "mpc_urandom", r_gmprandstate_mpc_urandom, -1);
}
