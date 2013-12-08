GNU MPC
=======

This gem provides Ruby bindings to the GNU MPC library.

Methods
=======

Projection and Decomposing Methods
----------------------------------

```ruby
MPC#real   # real part
MPC#imag   # imaginary part
MPC#arg    # argument
MPC#proj   # projection
```

Trigonometric Methods
---------------------

The GNU MPC gem provides bindings to the following functions from MPC:

```ruby
MPC#sin    # sine
MPC#cos    # cosine
MPC#tan    # tangent
MPC#sinh   # hyperbolic sine
MPC#cosh   # hyperbolic cosine
MPC#tanh   # hyperbolic tangent
MPC#asin   # inverse sine
MPC#acos   # inverse cosine
MPC#atan   # inverse tangent
```

...

Each of these methods accepts optional arguments to specify the rounding mode,
and precision, in the following fashions:

```
z = MPC.new(0, 1)
z.sin()                                    # default rounding mode; precision of the receiver is
                                           # applied to the return value
z.sin(MPC::MPC_RNDZZ)                      # MPC_RNDZZ rounding mode; precision of the receiver
                                           # is applied to the return value
z.sin(MPC::MPC_RNDNN, 64)                  # MPC_RNDNN rounding mode; precision of both real and
                                           # imaginary parts of return value is 64
z.sin(MPC::MPC_RNDNN, 64, 128)             # MPC_RNDNN rounding mode; precision
                                           # of real part of return value is 64,
                                           # imaginary part is 128
z.sin(:rounding => MPC::MPC_RNDZZ)         # MPC_RNDZZ rounding mode; precision
                                           # of the receiver is applied to the
                                           # return value
z.sin(:prec => 64)                         # default rounding mode; precision of
                                           # both real and imaginary parts of
                                           # return value is 64
z.sin(:pre_real => 64, :prec_imag => 128)  # default rounding mode; precision of
                                           # real part of return value is 64,
                                           # imaginary part is 128
```

Either the ordered list of arguments, or the options Hash may be passed; they
cannot be mixed.
