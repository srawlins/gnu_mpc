/*
 * mpc.c
 *
 * This file contains everything you would expect from a C extension.
 */

#include <ruby_mpc.h>

/*
 * Document-class: MPC
 *
 * GMP Multiple Precision Complex numbers
 *
 * Instances of this class can store variables of the type mpc_t. This class
 * also contains many methods that act as the functions for mpc_t variables,
 * as well as a few methods that attempt to make this library more Ruby-ish.
 */

/*
 * Macros
 */

#define MPC_SINGLE_FUNCTION(name)                                                            \
VALUE r_mpc_##name(int argc, VALUE *argv, VALUE self_val)                                    \
{                                                                                            \
  MP_COMPLEX *self, *res;                                                                    \
  VALUE rnd_mode_val;                                                                        \
  VALUE res_real_prec_val, res_imag_prec_val;                                                \
  VALUE res_val;                                                                             \
                                                                                             \
  mpfr_prec_t real_prec, imag_prec;                                                          \
  mpfr_prec_t res_real_prec, res_imag_prec;                                                  \
  mpc_rnd_t rnd_mode;                                                                        \
                                                                                             \
  mpc_get_struct(self_val, self);                                                            \
  real_prec = mpfr_get_prec(mpc_realref(self));                                              \
  imag_prec = mpfr_get_prec(mpc_imagref(self));                                              \
                                                                                             \
  if (argc > 0 && TYPE(argv[0]) == T_HASH) {                                                 \
    rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);                  \
    res_real_prec = real_prec;                                                               \
    res_imag_prec = imag_prec;                                                               \
  } else {                                                                                   \
    rb_scan_args (argc, argv, "03", &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);  \
                                                                                             \
    r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,              \
                           &rnd_mode,    &res_real_prec,    &res_imag_prec,                  \
                                              real_prec,         imag_prec);                 \
  }                                                                                          \
                                                                                             \
  mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);                        \
  mpc_##name (res, self, rnd_mode);                                                          \
                                                                                             \
  return res_val;                                                                            \
}

/*
 * Helper Methods
 */
void r_mpc_set_default_args (VALUE rnd_mode_val,    VALUE res_real_prec_val,    VALUE res_imag_prec_val,
                        mpc_rnd_t *rnd_mode, mpfr_prec_t *res_real_prec, mpfr_prec_t *res_imag_prec,
                                             mpfr_prec_t      real_prec, mpfr_prec_t      imag_prec) {
  if (NIL_P (rnd_mode_val)) { *rnd_mode = __gmp_default_rounding_mode; }
  else { *rnd_mode = r_mpc_get_rounding_mode(rnd_mode_val); }

  if (NIL_P (res_real_prec_val) && NIL_P (res_imag_prec_val)) {
    *res_real_prec = real_prec;
    *res_imag_prec = imag_prec;
  } else if (NIL_P (res_imag_prec_val)) {
    *res_real_prec = FIX2INT( res_real_prec_val);
    *res_imag_prec = FIX2INT( res_real_prec_val);
  } else {
    *res_real_prec = FIX2INT( res_real_prec_val);
    *res_imag_prec = FIX2INT( res_imag_prec_val);
  }
}

void rb_mpc_get_hash_arguments(mpc_rnd_t *rnd_mode, mpfr_prec_t *real_prec, mpfr_prec_t *imag_prec, VALUE hash) {
  VALUE rnd_mode_val;
  VALUE real_prec_val;
  VALUE rounding_mode_sym, rounding_sym, round_sym, rnd_sym;
  VALUE precision_sym, prec_sym;
  rounding_mode_sym = ID2SYM(rb_intern("rounding_mode"));
  rounding_sym      = ID2SYM(rb_intern("rounding"));
  round_sym         = ID2SYM(rb_intern("round"));
  rnd_sym           = ID2SYM(rb_intern("rnd"));
  precision_sym     = ID2SYM(rb_intern("precision"));
  prec_sym          = ID2SYM(rb_intern("prec"));

  rnd_mode_val = rb_hash_aref(hash, rounding_mode_sym);
  if (rnd_mode_val == Qnil) { rnd_mode_val = rb_hash_aref(hash, rounding_sym); }
  if (rnd_mode_val == Qnil) { rnd_mode_val = rb_hash_aref(hash, round_sym); }
  if (rnd_mode_val == Qnil) { rnd_mode_val = rb_hash_aref(hash, rnd_sym); }
  if (rnd_mode_val != Qnil) {
    *rnd_mode = r_mpc_get_rounding_mode(rnd_mode_val);
  } else {
    *rnd_mode = __gmp_default_rounding_mode;
  }

  /* TODO: allow prec */
  /* TODO: allow real_prec, imag_prec */
  real_prec_val = rb_hash_aref(hash, precision_sym);
  if (real_prec_val == Qnil) { real_prec_val = rb_hash_aref(hash, prec_sym); }
  if (real_prec_val != Qnil) {
    *real_prec = FIX2INT (real_prec_val);
    *imag_prec = FIX2INT (real_prec_val);
  } else {
  }

  /* TODO: disallow any other args. Throw a fit. */
}

/*
 *    Internal helper functions
 ***/

int rb_base_type_range_check(VALUE base)
{
  int base_val;
  if (NIL_P (base)) { base_val = 10; }
  else {
    if (FIXNUM_P (base))
      if (FIX2NUM (base) >= 2 && FIX2NUM (base) <= 36)
        base_val = FIX2NUM (base);
      else
        rb_raise (rb_eRangeError, "base must be between 2 and 36.");
    else
      rb_raise (rb_eTypeError, "base must be a Fixnum.");
  }
  return base_val;
}

size_t rb_sig_figs_type_range_check(VALUE sig_figs)
{
  size_t sig_figs_val;
  if (NIL_P (sig_figs)) { sig_figs_val = (size_t)(0); }
  else {
    if (FIXNUM_P (sig_figs))
      if (FIX2NUM (sig_figs) >= 0)
        sig_figs_val = (size_t)(FIX2NUM (sig_figs));
      else
        rb_raise (rb_eRangeError, "significant figures must be greater than or equal to 0.");
    else
      rb_raise (rb_eTypeError, "significant figures must be a Fixnum.");
  }
  return sig_figs_val;
}


/*********************************************************************
 *    Initialization Functions                                       *
 *********************************************************************/

VALUE cMPC;
VALUE cMPC_Rnd;
void r_mpc_free(void *ptr) { mpc_clear (ptr); free (ptr); }

mpc_rnd_t r_get_mpc_rounding_mode(VALUE rnd)
{
  VALUE mode;

  if (MPCRND_P (rnd)) {
    mode = rb_funcall (rnd, rb_intern ("mode"), 0);
    if (FIX2INT (mode) < 0 || FIX2INT (mode) > 63) {
      rb_raise (rb_eRangeError, "rounding mode must be one of the MPC rounding mode constants.");
    }
  } else {
    rb_raise (rb_eTypeError, "rounding mode must be one of the MPC rounding mode constants.");
  }

  switch (FIX2INT (mode)) {
    case  0:
      return MPC_RNDNN;
    case  1:
      return MPC_RNDZN;
    case  2:
      return MPC_RNDUN;
    case  3:
      return MPC_RNDDN;
    case 16:
      return MPC_RNDNZ;
    case 17:
      return MPC_RNDZZ;
    case 18:
      return MPC_RNDUZ;
    case 19:
      return MPC_RNDDZ;
    case 32:
      return MPC_RNDNU;
    case 33:
      return MPC_RNDZU;
    case 34:
      return MPC_RNDUU;
    case 35:
      return MPC_RNDDU;
    case 48:
      return MPC_RNDND;
    case 49:
      return MPC_RNDZD;
    case 50:
      return MPC_RNDUD;
    case 51:
      return MPC_RNDDD;
    default:
      return MPC_RNDNN;
  }
}

/*
 * call-seq:
 *   MPC.new(value = 0)
 *
 * Creates a new MPC complex number, with _value_ as its value, converting where necessary.
 * _value_ must be an instance of one of the following classes:
 *
 * * MPC
 * * GMP::Z
 * * GMP::F
 * * Fixnum
 * * String
 * * Bignum
 *
 * @example
 *   MPC.new(5)  #=> 5
 *
 * @todo support #new(c, prec)
 * @todo support #new(c, prec_r, prec_i)
 */
VALUE r_mpcsg_new(int argc, VALUE *argv, VALUE klass)
{
  MP_COMPLEX *res_val;
  VALUE res;
  (void)klass;

  if (argc > 3)
    rb_raise (rb_eArgError, "wrong # of arguments (%d for 0, 1, 2, or 3)", argc);

  mpc_make_struct (res, res_val);
  rb_obj_call_init (res, argc, argv);

  return res;
}

VALUE r_mpc_initialize(int argc, VALUE *argv, VALUE self)
{
  MP_COMPLEX *self_val;
  MP_FLOAT *arg_val_f;
  MP_COMPLEX *arg_val_c;
  unsigned long prec = 0;
  mpfr_prec_t prec_re = 0;
  mpfr_prec_t prec_im = 0;
  mpc_rnd_t rnd_mode_val = r_mpc_default_rounding_mode;
  VALUE arg;

  mpc_get_struct (self, self_val);

  if (argc==0) {
    mpc_init2 (self_val, mpfr_get_default_prec());
    mpc_set_si (self_val, 0, rnd_mode_val);
    return Qnil;
  }

  arg = argv[0];

  // argc = 2 ==> argv[0] is value, argv[1] is prec
  //           OR argv[0] is value, argv[1] is rnd
  if (argc >= 2) {
    if (FIXNUM_P (argv[1])) {
      if (FIX2INT (argv[1]) >= 0)
        prec = FIX2INT (argv[1]);
      else {
        mpc_init2 (self_val, mpfr_get_default_prec());
        rb_raise (rb_eRangeError, "prec must be non-negative");
      }
    } else if (MPCRND_P (argv[1])) {
      rnd_mode_val = r_get_mpc_rounding_mode(argv[1]);
    } else {
      mpc_init2 (self_val, mpfr_get_default_prec());
      rb_raise (rb_eTypeError, "don't know how to interpret argument 1, a %s", rb_class2name (rb_class_of (argv[1])));
    }
  // if no precision provided, but an mpfr_t is passed as value, use its prec
  } else if (GMPF_P (arg)) {
    mpf_get_struct (arg, arg_val_f);
    prec = mpf_get_prec (arg_val_f);
  // if no precision provided, but an mpc_t is passed as value, use its prec
  } else if (MPC_P (arg)) {
    mpc_get_struct (arg, arg_val_c);
    mpc_get_prec2 (&prec_re, &prec_im, arg_val_c);
  }

  // argc = 3 ==> argv[0] is value, argv[1] is prec_r, argv[2] is prec_i
  //           OR argv[0] is value, argv[1] is prec,   argv[2] is rnd
  if (argc == 3) {
    if (MPCRND_P (argv[1])) {
      mpc_init2 (self_val, mpfr_get_default_prec());
      rb_raise (rb_eArgError, "the rounding mode should be the last argument");
    } else if (FIXNUM_P (argv[2])) {
      if (FIX2INT (argv[2]) >= 0) {
        // argv[1] was actually prec_r and //argv[2] is prec_i
        prec_re = (mpfr_prec_t) prec;
        prec_im = FIX2INT (argv[2]);
        prec = 0;
      } else {
        mpc_init2 (self_val, mpfr_get_default_prec());
        rb_raise (rb_eRangeError, "prec_im must be non-negative");
      }
    } else if (MPCRND_P (argv[2])) {
      rnd_mode_val = r_get_mpc_rounding_mode(argv[2]);
    } else {
      mpc_init2 (self_val, mpfr_get_default_prec());
      rb_raise (rb_eTypeError, "don't know how to interpret argument 2, a %s", rb_class2name (rb_class_of (argv[2])));
    }
  }

  // argc = 4 ==> argv[0] is value, argv[1] is prec_r, argv[2] is prec_i, argv[3] is rnd
  // TODO

  if (prec == 0)
    mpc_init2 (self_val, mpfr_get_default_prec());
  else
    mpc_init2 (self_val, prec);

  if (STRING_P (argv[0])) {
    // unfortunately, we cannot accept an explicit base, as we do in r_gmpf_initialize.
    // #new(c, prec, base) would be indistinguishable from #new(c, prec_r, prec_i).
    // TODO allow this behavior via something like #new_str or String#to_mpc
    mpc_set_str (self_val, StringValuePtr(arg), 0, rnd_mode_val);
    return Qnil;
  }

  //if (MPC_P(arg)) {
  //  mpc_get_struct (arg, arg_val_c);
  //  mpc_set (self_val, arg_val_c, rnd_mode_val);
  //} else {
    mpc_set_value (self_val, arg, rnd_mode_val);
  //}

  return Qnil;
}

void mpc_set_value(MP_COMPLEX *self_val, VALUE arg, mpc_rnd_t rnd)
{
  MP_INT     *arg_val_z, *arg_val_z_im;
  MP_RAT     *arg_val_q, *arg_val_q_im;
  MP_FLOAT   *arg_val_f, *arg_val_f_im;
  MP_COMPLEX *arg_val_c;
  VALUE arg_re, arg_im;

  if (FIXNUM_P (arg)) {
    mpc_set_si(self_val, FIX2NUM (arg), rnd);
  } else if (FLOAT_P (arg)) {
    mpc_set_d (self_val, NUM2DBL (arg), rnd);
  } else if (GMPQ_P (arg)) {
    mpq_get_struct (arg, arg_val_q);
    mpc_set_q (self_val, arg_val_q, rnd);
  } else if (GMPZ_P (arg)) {
    mpz_get_struct (arg, arg_val_z);
    mpc_set_z (self_val, arg_val_z, rnd);
  // TODO STRING_P
  // TODO BIGNUM_P
  } else if (MPC_P (arg)) {
    mpc_get_struct (arg, arg_val_c);
    mpc_set (self_val, arg_val_c, rnd);
  } else if (GMPF_P (arg)) {
    mpf_get_struct (arg, arg_val_f);
    mpc_set_fr (self_val, arg_val_f, rnd);
  } else if (ARRAY_P (arg)) {
    //if (RARRAY(arg)->len != 2)
      //rb_raise(rb_eArgError, "Value Array must contain exactly two elements, the real value, and the imaginary value.");
    arg_re = rb_ary_shift(arg);
    arg_im = rb_ary_shift(arg);
    if (FIXNUM_P (arg_re) && FIXNUM_P (arg_im)) {
      mpc_set_si_si (self_val, FIX2NUM (arg_re), FIX2NUM (arg_im), rnd);
    } else if (FLOAT_P (arg_re) && FLOAT_P (arg_im)) {
      mpc_set_d_d (self_val, NUM2DBL (arg_re), NUM2DBL (arg_im), rnd);
    } else if (GMPZ_P (arg_re) && GMPZ_P (arg_im)) {
      mpz_get_struct (arg_re, arg_val_z);
      mpz_get_struct (arg_im, arg_val_z_im);
      mpc_set_z_z (self_val, arg_val_z, arg_val_z_im, rnd);
    } else if (GMPQ_P (arg_re) && GMPQ_P (arg_im)) {
      mpq_get_struct (arg_re, arg_val_q);
      mpq_get_struct (arg_im, arg_val_q_im);
      mpc_set_q_q (self_val, arg_val_q, arg_val_q_im, rnd);
    } else if (GMPF_P (arg_re) && GMPF_P (arg_im)) {
      mpf_get_struct (arg_re, arg_val_f);
      mpf_get_struct (arg_im, arg_val_f_im);
      mpc_set_fr_fr (self_val, arg_val_f, arg_val_f_im, rnd);
    // TODO STRING_P
    // TODO BIGNUM_P
    } else
      rb_raise(rb_eTypeError, "Real and imaginary values must be of the same type.");
  } else {
    rb_raise(rb_eTypeError, "Don't know how to convert %s into MPC", rb_class2name (rb_class_of(arg)));
  }
}

/*
 * call-seq:
 *   c.prec
 *
 * If the real and imaginary part of _c_ have the same precision, it is returned. Otherwise,
 * 0 is returned.
 */
VALUE r_mpc_prec(VALUE self)
{
  MP_COMPLEX *self_val;
  mpc_get_struct (self, self_val);
  return INT2NUM (mpc_get_prec (self_val));
}


/*********************************************************************
 *    String and Stream Input and Output                             *
 *********************************************************************/

/*
 * call-seq:
 *   c.to_s
 *
 * Returns the decimal representation of the real part and imaginary part of _c_, as a String.
 *
 * @TODO type check, range check optional argument: rounding mode
 */
VALUE r_mpc_to_s(int argc, VALUE *argv, VALUE self)
{
  MP_COMPLEX *self_val;
  char *str;
  VALUE base, sig_figs, rnd_mode, res;
  int base_val;
  size_t sig_figs_val;
  mpc_rnd_t rnd_mode_val;
  //mp_exp_t exponent;

  mpc_get_struct (self, self_val)

  rb_scan_args (argc, argv, "03", &base, &sig_figs, &rnd_mode);
  base_val = rb_base_type_range_check (base);
  sig_figs_val = rb_sig_figs_type_range_check (sig_figs);
  //if (NIL_P (sig_figs)) { sig_figs_val = (size_t)(0); }
  //else {                  sig_figs_val = (size_t)(FIX2NUM(sig_figs)); }
  if (NIL_P (rnd_mode)) { rnd_mode_val = r_mpc_default_rounding_mode; }
  else {                  rnd_mode_val = r_get_mpc_rounding_mode(rnd_mode); }

  str = mpc_get_str (base_val, sig_figs_val, self_val, rnd_mode_val);
  res = rb_str_new2 (str);

  mpc_free_str (str);
  return res;
}


/*********************************************************************
 *    Comparison Functions                                           *
 *********************************************************************/

int mpc_cmp_value(MP_COMPLEX *self_val, VALUE arg)
{
  MP_COMPLEX *arg_val;
  int result;

  if (MPC_P (arg)) {
    mpc_get_struct (arg,arg_val);
    return mpc_cmp (self_val, arg_val);
  } else {
    mpc_temp_init (arg_val, mpc_get_prec (self_val));
    mpc_set_value (arg_val, arg, r_mpc_default_rounding_mode);
    result = mpc_cmp (self_val, arg_val);
    mpc_temp_free (arg_val);
    return result;
  }
}

VALUE r_mpc_eq(VALUE self, VALUE arg)
{
  MP_COMPLEX *self_val;
  mpc_get_struct (self,self_val);
  return (mpc_cmp_value (self_val, arg) == 0) ? Qtrue : Qfalse;
}

VALUE r_mpc_cmp(VALUE self, VALUE arg)
{
  MP_COMPLEX *self_val;
  int res;
  mpc_get_struct (self, self_val);
  res = mpc_cmp_value (self_val, arg);
  return rb_assoc_new(INT2FIX(MPC_INEX_RE(res)), INT2FIX (MPC_INEX_IM(res)));
}


/*********************************************************************
 *    Projection and Decomposition Functions                         *
 *********************************************************************/

/*
 * DEFUN_COMPLEX2FLOAT defines a function. This function takes an
 * MPC as self, calls mpc_fname on the contained mpc_t, whose
 * arguments are exactly (0) the return argument (an mpfr_t), (1) self,
 * and (2) the rounding mode.
 */
#define DEFUN_COMPLEX2FLOAT(fname, prec_src)                                 \
static VALUE r_mpc_##fname(int argc, VALUE *argv, VALUE self_val)            \
{                                                                            \
  MP_COMPLEX *self;                                                          \
  MP_FLOAT *res;                                                             \
  VALUE rnd_mode_val, res_val, res_prec_val;                                 \
                                                                             \
  mpfr_prec_t real_prec, imag_prec;                                          \
  mpfr_prec_t res_prec;                                                      \
  mpc_rnd_t rnd_mode;                                                        \
                                                                             \
  mpc_get_struct(self_val, self);                                            \
  real_prec = mpfr_get_prec(mpc_realref(self));                              \
  imag_prec = mpfr_get_prec(mpc_imagref(self));                              \
                                                                             \
  if (argc > 0 && TYPE(argv[0]) == T_HASH) {                                 \
    rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);  \
    res_prec = prec_src;                                                     \
  } else {                                                                   \
    rb_scan_args (argc, argv, "02", &rnd_mode_val, &res_prec_val);           \
                                                                             \
    if (NIL_P (rnd_mode_val)) { rnd_mode = __gmp_default_rounding_mode; }    \
    else { rnd_mode = r_mpc_get_rounding_mode(rnd_mode_val); }               \
                                                                             \
    if (NIL_P (res_prec_val)) { res_prec = prec_src; }                       \
    else { res_prec = FIX2INT(res_prec_val); }                               \
  }                                                                          \
                                                                             \
  mpf_make_struct (res_val, res);                                            \
  mpfr_init2 (res, res_prec);                                                \
  mpc_##fname (res, self, rnd_mode);                                         \
                                                                             \
  return res_val;                                                            \
}


/*
 * call-seq:
 *   c.real
 *   c.real(rounding_mode)
 *   c.real(rounding_mode, precision)
 *
 * Returns the real part of _c_ as a GMP_F float (an MPFR float, really).
 */
DEFUN_COMPLEX2FLOAT(real, real_prec)

/*
 * call-seq:
 *   c.imag
 *   c.imag(rounding_mode)
 *   c.imag(rounding_mode, precision)
 *
 * Returns the imaginary part of _c_ as a GMP_F float (an MPFR float, really).
 */
DEFUN_COMPLEX2FLOAT(imag, imag_prec)

MPC_SINGLE_FUNCTION(proj)

/*********************************************************************
 *    Basic Arithmetic Functions                                     *
 *********************************************************************/

/*
 * All of the arithmetic functions will need a lot of massaging ability. For
 * example, there are only 3 variants of mpc_add, one that takes an mpc_t, one
 * that takes an unsigned long int, and one that takes an mpfr_t. Here is a
 * table of the massagings:
 *
 * z + x
 * =====
 *
 * x:Fixnum =>
 *     x  > 0 => mpc_add_ui ( z, (unsigned long int)x )
 *     x  < 0 => mpc_sub_ui ( z, (unsigned long int)x )
 *     x == 0 => z
 * x:Bignum =>   mpc_add_fr ( z, (mpfr_t)x )
 * x:GMP::Z =>   mpc_add_fr ( z, (mpfr_t)x )
 * x:GMP::Q =>   mpc_add_fr ( z, (mpfr_t)x )
 * x:Float  =>   mpc_add_fr ( z, (mpfr_t)x )
 * x:GMP::F =>   mpc_add_fr ( z, x )
 * x:MPC =>      mpc_add ( z, x )
 */

VALUE r_mpc_add_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec);
VALUE r_mpc_add(int argc, VALUE *argv, VALUE self_val)
{
  MP_COMPLEX *self;
  VALUE rnd_mode_val;
  VALUE  res_real_prec_val, res_imag_prec_val;
  VALUE arg_val;

  mpfr_prec_t real_prec, imag_prec;
  mpfr_prec_t res_real_prec, res_imag_prec;
  mpc_rnd_t rnd_mode;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  //if (argc > 0 && TYPE(argv[0]) == T_HASH) {
  //  rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);
    //res_real_prec = real_prec;
    //res_imag_prec = imag_prec;
  //} else {
    rb_scan_args (argc, argv, "13", &arg_val, &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);

    r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,
                           &rnd_mode,    &res_real_prec,    &res_imag_prec,
                                              real_prec,         imag_prec);
  //}

  //return res_val;
  return r_mpc_add_do_the_work(self_val, arg_val, rnd_mode, res_real_prec, res_imag_prec);
}

VALUE r_mpc_add2(VALUE self_val, VALUE arg_val)
{
  MP_COMPLEX *self;

  mpfr_prec_t res_real_prec, res_imag_prec;

  mpc_get_struct(self_val, self);
  res_real_prec = mpfr_get_prec(mpc_realref(self));
  res_imag_prec = mpfr_get_prec(mpc_imagref(self));

  return r_mpc_add_do_the_work(self_val, arg_val, MPC_RNDNN, res_real_prec, res_imag_prec);
}

VALUE r_mpc_add_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec) {
  MP_COMPLEX *self, *res, *arg_c;
  MP_INT *arg_z;
  MP_FLOAT *arg_f;
  VALUE res_val;

  mpc_get_struct(self_val,self);

  if (FIXNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    if (FIX2NUM (arg_val) >= 0) {
      mpc_add_ui (res, self,  FIX2NUM (arg_val), rnd_mode);
    } else {
      mpc_sub_ui (res, self, -FIX2NUM (arg_val), rnd_mode);
    }
  } else if (BIGNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_temp_from_bignum (arg_z, arg_val);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpz_temp_free (arg_z);
    mpc_add (res, self, res, rnd_mode);
  } else if (GMPZ_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_get_struct (arg_val, arg_z);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpc_add (res, self, res, rnd_mode);
  } else if (GMPF_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpf_get_struct (arg_val, arg_f);
    mpc_add_fr (res, self, arg_f, rnd_mode);
  } else if (MPC_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpc_get_struct (arg_val, arg_c);
    mpc_add (res, self, arg_c, rnd_mode);
  } else {
    typeerror(FXC);
  }

  return res_val;
}

VALUE r_mpc_sub_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec);
VALUE r_mpc_sub(int argc, VALUE *argv, VALUE self_val)
{
  MP_COMPLEX *self;
  VALUE rnd_mode_val;
  VALUE  res_real_prec_val, res_imag_prec_val;
  VALUE arg_val;

  mpfr_prec_t real_prec, imag_prec;
  mpfr_prec_t res_real_prec, res_imag_prec;
  mpc_rnd_t rnd_mode;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  //if (argc > 0 && TYPE(argv[0]) == T_HASH) {
  //  rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);
    //res_real_prec = real_prec;
    //res_imag_prec = imag_prec;
  //} else {
    rb_scan_args (argc, argv, "13", &arg_val, &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);

    r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,
                           &rnd_mode,    &res_real_prec,    &res_imag_prec,
                                              real_prec,         imag_prec);
  //}

  //return res_val;
  return r_mpc_sub_do_the_work(self_val, arg_val, rnd_mode, res_real_prec, res_imag_prec);
}

VALUE r_mpc_sub2(VALUE self_val, VALUE arg_val)
{
  MP_COMPLEX *self;

  mpfr_prec_t res_real_prec, res_imag_prec;

  mpc_get_struct(self_val, self);
  res_real_prec = mpfr_get_prec(mpc_realref(self));
  res_imag_prec = mpfr_get_prec(mpc_imagref(self));

  return r_mpc_sub_do_the_work(self_val, arg_val, MPC_RNDNN, res_real_prec, res_imag_prec);
}

VALUE r_mpc_sub_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec) {
  MP_COMPLEX *self, *res, *arg_c;
  MP_INT *arg_z;
  MP_FLOAT *arg_f;
  VALUE res_val;

  mpc_get_struct(self_val,self);

  if (FIXNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    if (FIX2NUM (arg_val) >= 0) {
      mpc_sub_ui (res, self,  FIX2NUM (arg_val), rnd_mode);
    } else {
      mpc_add_ui (res, self, -FIX2NUM (arg_val), rnd_mode);
    }
  } else if (BIGNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_temp_from_bignum (arg_z, arg_val);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpz_temp_free (arg_z);
    mpc_sub (res, self, res, rnd_mode);
  } else if (GMPZ_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_get_struct (arg_val, arg_z);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpc_sub (res, self, res, rnd_mode);
  } else if (GMPF_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpf_get_struct (arg_val, arg_f);
    mpc_sub_fr (res, self, arg_f, rnd_mode);
  } else if (MPC_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpc_get_struct (arg_val, arg_c);
    mpc_sub (res, self, arg_c, rnd_mode);
  } else {
    typeerror(FXC);
  }

  return res_val;
}

VALUE r_mpc_mul_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec);
VALUE r_mpc_mul(int argc, VALUE *argv, VALUE self_val)
{
  MP_COMPLEX *self;
  VALUE rnd_mode_val;
  VALUE res_real_prec_val, res_imag_prec_val;
  VALUE arg_val;

  mpfr_prec_t real_prec, imag_prec;
  mpfr_prec_t res_real_prec, res_imag_prec;
  mpc_rnd_t rnd_mode;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  //if (argc > 0 && TYPE(argv[0]) == T_HASH) {
  //  rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);
    //res_real_prec = real_prec;
    //res_imag_prec = imag_prec;
  //} else {
    rb_scan_args (argc, argv, "13", &arg_val, &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);

    r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,
                           &rnd_mode,    &res_real_prec,    &res_imag_prec,
                                              real_prec,         imag_prec);
  //}

  //return res_val;
  return r_mpc_mul_do_the_work(self_val, arg_val, rnd_mode, res_real_prec, res_imag_prec);
}

VALUE r_mpc_mul2(VALUE self_val, VALUE arg_val)
{
  MP_COMPLEX *self;

  mpfr_prec_t res_real_prec, res_imag_prec;

  mpc_get_struct(self_val, self);
  res_real_prec = mpfr_get_prec(mpc_realref(self));
  res_imag_prec = mpfr_get_prec(mpc_imagref(self));

  return r_mpc_mul_do_the_work(self_val, arg_val, MPC_RNDNN, res_real_prec, res_imag_prec);
}

VALUE r_mpc_mul_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec) {
  MP_COMPLEX *self, *res, *arg_c;
  MP_INT *arg_z;
  MP_FLOAT *arg_f;
  VALUE res_val;

  mpc_get_struct(self_val,self);

  if (FIXNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    if (FIX2NUM (arg_val) >= 0) {
      mpc_mul_ui (res, self, FIX2NUM (arg_val), rnd_mode);
    } else {
      mpc_mul_si (res, self, FIX2NUM (arg_val), rnd_mode);
    }
  } else if (BIGNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_temp_from_bignum (arg_z, arg_val);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpz_temp_free (arg_z);
    mpc_mul (res, self, res, rnd_mode);
  } else if (GMPZ_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_get_struct (arg_val, arg_z);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpc_mul (res, self, res, rnd_mode);
  } else if (GMPF_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpf_get_struct (arg_val, arg_f);
    mpc_mul_fr (res, self, arg_f, rnd_mode);
  } else if (MPC_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpc_get_struct (arg_val, arg_c);
    mpc_mul (res, self, arg_c, rnd_mode);
  } else {
    typeerror(FXC);
  }

  return res_val;
}

VALUE r_mpc_mul_i(int argc, VALUE *argv, VALUE self_val)
{
  MP_COMPLEX *self, *res;
  VALUE rnd_mode_val;
  VALUE res_real_prec_val, res_imag_prec_val;
  VALUE sign_val, res_val;

  mpfr_prec_t real_prec, imag_prec;
  mpfr_prec_t res_real_prec, res_imag_prec;
  mpc_rnd_t rnd_mode;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  rb_scan_args (argc, argv, "13", &sign_val, &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);

  r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,
                         &rnd_mode,    &res_real_prec,    &res_imag_prec,
                                            real_prec,         imag_prec);

  if (! FIXNUM_P (sign_val))
    typeerror(X);

  mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
  mpc_mul_i (res, self, FIX2INT(sign_val), rnd_mode);

  return res_val;
}

VALUE r_mpc_div_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec);
VALUE r_mpc_div(int argc, VALUE *argv, VALUE self_val)
{
  MP_COMPLEX *self;
  VALUE rnd_mode_val;
  VALUE  res_real_prec_val, res_imag_prec_val;
  VALUE arg_val;

  mpfr_prec_t real_prec, imag_prec;
  mpfr_prec_t res_real_prec, res_imag_prec;
  mpc_rnd_t rnd_mode;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  //if (argc > 0 && TYPE(argv[0]) == T_HASH) {
  //  rb_mpc_get_hash_arguments (&rnd_mode, &real_prec, &imag_prec, argv[0]);
    //res_real_prec = real_prec;
    //res_imag_prec = imag_prec;
  //} else {
    rb_scan_args (argc, argv, "13", &arg_val, &rnd_mode_val, &res_real_prec_val, &res_imag_prec_val);

    r_mpc_set_default_args (rnd_mode_val, res_real_prec_val, res_imag_prec_val,
                           &rnd_mode,    &res_real_prec,    &res_imag_prec,
                                              real_prec,         imag_prec);
  //}

  //return res_val;
  return r_mpc_div_do_the_work(self_val, arg_val, rnd_mode, res_real_prec, res_imag_prec);
}

VALUE r_mpc_div2(VALUE self_val, VALUE arg_val)
{
  MP_COMPLEX *self;

  mpfr_prec_t res_real_prec, res_imag_prec;

  mpc_get_struct(self_val, self);
  res_real_prec = mpfr_get_prec(mpc_realref(self));
  res_imag_prec = mpfr_get_prec(mpc_imagref(self));

  return r_mpc_div_do_the_work(self_val, arg_val, MPC_RNDNN, res_real_prec, res_imag_prec);
}

VALUE r_mpc_div_do_the_work(VALUE self_val, VALUE arg_val, mpc_rnd_t rnd_mode, mpfr_prec_t res_real_prec, mpfr_prec_t res_imag_prec) {
  MP_COMPLEX *self, *res, *arg_c;
  MP_INT *arg_z;
  MP_FLOAT *arg_f;
  VALUE res_val;

  mpc_get_struct(self_val,self);

  if (FIXNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    if (FIX2NUM (arg_val) >= 0) {
      mpc_div_ui (res, self,  FIX2NUM (arg_val), rnd_mode);
    } else {
      mpc_div_ui (res, self, -FIX2NUM (arg_val), rnd_mode);
      mpc_neg (res, res, rnd_mode);
    }
  } else if (BIGNUM_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_temp_from_bignum (arg_z, arg_val);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpz_temp_free (arg_z);
    mpc_div (res, self, res, rnd_mode);
  } else if (GMPZ_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpz_get_struct (arg_val, arg_z);
    mpc_set_z (res, arg_z, MPC_RNDNN);
    mpc_div (res, self, res, rnd_mode);
  } else if (GMPF_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpf_get_struct (arg_val, arg_f);
    mpc_div_fr (res, self, arg_f, rnd_mode);
  } else if (MPC_P (arg_val)) {
    mpc_make_struct_init3 (res_val, res, res_real_prec, res_imag_prec);
    mpc_get_struct (arg_val, arg_c);
    mpc_div (res, self, arg_c, rnd_mode);
  } else {
    typeerror(FXC);
  }

  return res_val;
}

MPC_SINGLE_FUNCTION(neg)

/*
 * call-seq:
 *   -z
 *
 * Returns _-z_, rounded according to the default rounding mode.
 */
VALUE r_mpc_neg2(VALUE self_val)
{
  MP_COMPLEX *self, *res;
  VALUE res_val;
  mpfr_prec_t real_prec, imag_prec;

  mpc_get_struct(self_val,self);
  real_prec = mpfr_get_prec(mpc_realref(self));
  imag_prec = mpfr_get_prec(mpc_imagref(self));

  mpc_make_struct_init3 (res_val, res, real_prec, imag_prec);
  mpc_neg (res, self, __gmp_default_rounding_mode);

  return res_val;
}

MPC_SINGLE_FUNCTION(sqr)
MPC_SINGLE_FUNCTION(conj)

/*
 * call-seq:
 *   c.abs
 *   c.abs(rounding_mode)
 *
 * Returns the absolute value of _c_ as a GMP_F float (an MPFR float, really).
 */
VALUE r_mpc_abs(int argc, VALUE *argv, VALUE self)
{
  MP_COMPLEX *self_val;
  MP_FLOAT *abs_val;
  VALUE rnd_mode, abs;
  mpfr_prec_t pr=0, pi=0;
  mpc_rnd_t rnd_mode_val;

  mpc_get_struct (self, self_val);

  rb_scan_args (argc, argv, "01", &rnd_mode);
  if (NIL_P (rnd_mode)) { rnd_mode_val = r_mpc_default_rounding_mode; }
  else { rnd_mode_val = r_get_mpc_rounding_mode (rnd_mode); }

  mpf_make_struct (abs, abs_val);
  mpc_get_prec2 (&pr, &pi, self_val);
  mpfr_init2 (abs_val, pr);
  mpc_abs (abs_val, self_val, rnd_mode_val);
  return abs;
}

/*
 * call-seq:
 *   c.norm
 *   c.norm(rounding_mode)
 *
 * Returns the norm of _c_ (i.e., the square of its absolute value), as a GMP_F float (an MPFR float, really).
 */
VALUE r_mpc_norm(int argc, VALUE *argv, VALUE self)
{
  MP_COMPLEX *self_val;
  MP_FLOAT *norm_val;
  VALUE rnd_mode, norm;
  mpfr_prec_t pr=0, pi=0;
  mpc_rnd_t rnd_mode_val;

  mpc_get_struct (self, self_val);

  rb_scan_args (argc, argv, "01", &rnd_mode);
  if (NIL_P (rnd_mode)) { rnd_mode_val = r_mpc_default_rounding_mode; }
  else { rnd_mode_val = r_get_mpc_rounding_mode (rnd_mode); }

  mpf_make_struct (norm, norm_val);
  mpc_get_prec2 (&pr, &pi, self_val);
  mpfr_init2 (norm_val, pr);
  mpc_norm (norm_val, self_val, rnd_mode_val);
  return norm;
}

/*********************************************************************
 *    Power and Logarithm Functions                                  *
 *********************************************************************/

MPC_SINGLE_FUNCTION(sqrt)
MPC_SINGLE_FUNCTION(exp)
MPC_SINGLE_FUNCTION(log)
MPC_SINGLE_FUNCTION(log10)

/*********************************************************************
 *    Trigonometric Functions                                        *
 *********************************************************************/

/*
 * call-seq:
 *   z.sin
 *   z.sin(rounding_mode)
 *
 * Returns _sin(z)_, rounded according to `rounding_mode`.
 * s3
 */
MPC_SINGLE_FUNCTION(sin)
MPC_SINGLE_FUNCTION(cos)
MPC_SINGLE_FUNCTION(tan)
MPC_SINGLE_FUNCTION(sinh)
MPC_SINGLE_FUNCTION(cosh)
MPC_SINGLE_FUNCTION(tanh)
MPC_SINGLE_FUNCTION(asin)
MPC_SINGLE_FUNCTION(acos)
MPC_SINGLE_FUNCTION(atan)

void Init_mpc() {
  cMPC = rb_define_class ("MPC", rb_cNumeric);

  rb_define_const (cMPC, "MPC_VERSION",       rb_str_new2(MPC_VERSION_STRING));

  // Initialization Functions and Assignment Functions
  rb_define_singleton_method (cMPC, "new", r_mpcsg_new, -1);
  rb_define_method (cMPC, "initialize", r_mpc_initialize, -1);
  rb_define_method (cMPC, "prec", r_mpc_prec, 0);
  // TODO rb_define_method (cMPC, "prec2", r_mpc_prec, 0);
  // TODO rb_define_method (cMPC, "prec=", r_mpc_prec, 1);

  // Conversion Functions
  // TODO research Ruby's Complex; see if it uses complex.h

  // String and Stream Input and Output
  rb_define_method (cMPC, "to_s", r_mpc_to_s, -1);

  // Comparison Functions
  rb_define_method(cMPC, "<=>", r_mpc_cmp, 1);
  rb_define_method(cMPC, "==",  r_mpc_eq, 1);

  // Projection and Decomposing Functions
  rb_define_method (cMPC, "real", r_mpc_real, -1);
  rb_define_method (cMPC, "imag", r_mpc_imag, -1);
  //rb_define_method (cMPC, "arg",  r_mpc_arg,  -1);
  rb_define_method (cMPC, "proj", r_mpc_proj, -1);

  // Basic Arithmetic Functions
  rb_define_method (cMPC, "add",   r_mpc_add,   -1);
  rb_define_method (cMPC, "+",     r_mpc_add2,   1);
  rb_define_method (cMPC, "sub",   r_mpc_sub,   -1);
  rb_define_method (cMPC, "-",     r_mpc_sub2,   1);
  rb_define_method (cMPC, "neg",   r_mpc_neg,   -1);
  rb_define_method (cMPC, "-@",    r_mpc_neg2,   0);
  rb_define_method (cMPC, "mul",   r_mpc_mul,   -1);
  rb_define_method (cMPC, "*",     r_mpc_mul2,   1);
  rb_define_method (cMPC, "mul_i", r_mpc_mul_i, -1);
  rb_define_method (cMPC, "sqr",   r_mpc_sqr,   -1);
  // TODO rb_define_method (cMPC, "fma", r_mpc_fma, 2);
  rb_define_method (cMPC, "div",   r_mpc_div,   -1);
  rb_define_method (cMPC, "/",     r_mpc_div2,   1);
  rb_define_method (cMPC, "conj",  r_mpc_conj,  -1);
  rb_define_method (cMPC, "abs",   r_mpc_abs,   -1);
  rb_define_method (cMPC, "norm",  r_mpc_norm,  -1);
  // TODO rb_define_method (cMPC, "mul_2exp", r_mpc_mul_2exp, 1);
  // TODO rb_define_method (cMPC, "div_2exp", r_mpc_div_2exp, 1);

  // Power Functions and Logarithm
  rb_define_method (cMPC, "sqrt", r_mpc_sqrt, -1);
  // TODO rb_define_method (cMPC, "**", r_mpc_pow, 1);
  rb_define_method (cMPC, "exp", r_mpc_exp, -1);
  rb_define_method (cMPC, "log", r_mpc_log, -1);
  rb_define_method (cMPC, "log10", r_mpc_log10, -1);

  // Trigonometric Functions
  rb_define_method (cMPC, "sin", r_mpc_sin, -1);
  rb_define_method (cMPC, "cos", r_mpc_cos, -1);
  // TODO rb_define_method (cMPC, "sin_cos", r_mpc_sin_cos, -1);
  rb_define_method (cMPC, "tan", r_mpc_tan, -1);
  rb_define_method (cMPC, "sinh", r_mpc_sinh, -1);
  rb_define_method (cMPC, "cosh", r_mpc_cosh, -1);
  rb_define_method (cMPC, "tanh", r_mpc_tanh, -1);
  rb_define_method (cMPC, "asin", r_mpc_asin, -1);
  rb_define_method (cMPC, "acos", r_mpc_acos, -1);
  rb_define_method (cMPC, "atan", r_mpc_atan, -1);
  // TODO rb_define_method (cMPC, "asinh", r_mpc_asinh, -1);
  // TODO rb_define_method (cMPC, "acosh", r_mpc_acosh, -1);
  // TODO rb_define_method (cMPC, "atanh", r_mpc_atanh, -1);

  // Miscellaneous Functions
  // TODO rb_define_method (cMPC, "urandom", r_mpc_urandom, 1);

  init_mpcrnd();
}
