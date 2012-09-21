#include <ruby_mpc.h>

VALUE r_mpcrnd_initialize(int argc, VALUE *argv, VALUE self);

VALUE r_mpcrndsg_new(int argc, VALUE *argv, VALUE klass)
{
  VALUE res;
  int *res_value;
  (void)klass;
  res_value = 0;

  mpcrnd_make_struct(res, res_value);
  rb_obj_call_init(res, argc, argv);
  return res;
}

/*
 * MPC_RNDNN 0000 0000
 * MPC_RNDNZ 0001 0000
 * MPC_RNDNU 0010 0000
 * MPC_RNDND 0011 0000
 * MPC_RNDNA ---- ----
 * MPC_RNDZN 0000 0001
 * MPC_RNDZZ 0001 0001
 * MPC_RNDZU 0010 0001
 * MPC_RNDZD 0011 0001
 * MPC_RNDZA ---- ----
 * MPC_RNDUN 0000 0010
 * MPC_RNDUZ 0001 0010
 * MPC_RNDUU 0010 0010
 * MPC_RNDUD 0011 0010
 * MPC_RNDUA ---- ----
 * MPC_RNDDN 0000 0011
 * MPC_RNDDZ 0001 0011
 * MPC_RNDDU 0010 0011
 * MPC_RNDDD 0011 0011
 * MPC_RNDDA ---- ----
 * MPC_RNDAN ---- ----
 * MPC_RNDAZ ---- ----
 * MPC_RNDAU ---- ----
 * MPC_RNDAD ---- ----
 * MPC_RNDAA ---- ----
 */
VALUE r_mpcrnd_initialize(int argc, VALUE *argv, VALUE self)
{
  VALUE mode, name, ieee754;
  mode = argv[0];
  (void)argc;
  char name_val[12];

  switch (FIX2INT(mode) % 16) {
  case 0:
    sprintf(name_val, "MPC_RNDN");
    ieee754 = rb_str_new2("(roundTiesToEven,");
    break;
  case 1:
    sprintf(name_val, "MPC_RNDZ");
    ieee754 = rb_str_new2("(roundTowardZero,");
    break;
  case 2:
    sprintf(name_val, "MPC_RNDU");
    ieee754 = rb_str_new2("(roundTowardPositive,");
    break;
  case 3:
    sprintf(name_val, "MPC_RNDD");
    ieee754 = rb_str_new2("(roundTowardNegative,");
    break;
  default:
    sprintf(name_val, "MPC_RNDN");
    ieee754 = rb_str_new2("(roundTiesToEven,");
  }

  switch (FIX2INT(mode) >> 4) {
  case 0:
    sprintf(name_val, "%sN", name_val);
    rb_str_cat(ieee754, "roundTiesToEven)", 16);
    break;
  case 1:
    sprintf(name_val, "%sZ", name_val);
    rb_str_cat(ieee754, "roundTowardZero)", 16);
    break;
  case 2:
    sprintf(name_val, "%sU", name_val);
    rb_str_cat(ieee754, "roundTowardPositive)", 20);
    break;
  case 3:
    sprintf(name_val, "%sD", name_val);
    rb_str_cat(ieee754, "roundTowardNegative)", 20);
    break;
  default:
    sprintf(name_val, "%sN", name_val);
    rb_str_cat(ieee754, "roundTiesToEven)", 16);
  }

  name = rb_str_new2(name_val);
  rb_iv_set (self, "@mode", mode);
  rb_iv_set (self, "@name", name);
  rb_iv_set (self, "@ieee754", ieee754);
  return Qnil;
}

VALUE r_mpcrnd_inspect(VALUE self)
{
  return rb_iv_get (self, "@name");
}

mpc_rnd_t r_get_default_mpc_rounding_mode()
{
  return r_get_mpc_rounding_mode (rb_const_get (cMPC, rb_intern ("MPC_RNDNN")));
}

mpc_rnd_t r_mpc_get_rounding_mode(VALUE rnd)
{
  VALUE mode;

  if (MPCRND_P(rnd)) {
    mode = rb_funcall (rnd, rb_intern("mode"), 0);
    if (FIX2INT(mode) < 0 || FIX2INT(mode) > 51) {
      rb_raise(rb_eRangeError, "rounding mode must be one of the rounding mode constants.");
    }
  } else {
    rb_raise(rb_eTypeError, "rounding mode must be one of the rounding mode constants.");
  }

  switch (FIX2INT (mode)) {
    case 0:
      return MPC_RNDNN;
    case 1:
      return MPC_RNDZN;
    case 2:
      return MPC_RNDUN;
    case 3:
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

void init_mpcrnd()
{
  cMPC = rb_define_class ("MPC", rb_cNumeric);
  ID new_id = rb_intern ("new");

  cMPC_Rnd = rb_define_class_under (cMPC, "Rnd", rb_cObject);

  rb_define_singleton_method (cMPC_Rnd, "new", r_mpcrndsg_new, -1);
  rb_define_method (cMPC_Rnd, "initialize", r_mpcrnd_initialize, -1);
  rb_define_method (cMPC_Rnd, "inspect", r_mpcrnd_inspect, 0);

  rb_define_attr (cMPC_Rnd, "mode",    1, 0);
  rb_define_attr (cMPC_Rnd, "name",    1, 0);
  rb_define_attr (cMPC_Rnd, "ieee754", 1, 0);

  rb_define_const(cMPC, "MPC_RNDNN", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(0)));
  rb_define_const(cMPC, "MPC_RNDNZ", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(16)));
  rb_define_const(cMPC, "MPC_RNDNU", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(32)));
  rb_define_const(cMPC, "MPC_RNDND", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(48)));
  rb_define_const(cMPC, "MPC_RNDZN", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(1)));
  rb_define_const(cMPC, "MPC_RNDZZ", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(17)));
  rb_define_const(cMPC, "MPC_RNDZU", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(33)));
  rb_define_const(cMPC, "MPC_RNDZD", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(49)));
  rb_define_const(cMPC, "MPC_RNDUN", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(2)));
  rb_define_const(cMPC, "MPC_RNDUZ", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(18)));
  rb_define_const(cMPC, "MPC_RNDUU", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(34)));
  rb_define_const(cMPC, "MPC_RNDUD", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(50)));
  rb_define_const(cMPC, "MPC_RNDDN", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(3)));
  rb_define_const(cMPC, "MPC_RNDDZ", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(19)));
  rb_define_const(cMPC, "MPC_RNDDU", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(35)));
  rb_define_const(cMPC, "MPC_RNDDD", rb_funcall (cMPC_Rnd, new_id, 1, INT2FIX(51)));
}
