GNU MPC
=======

This gem provides Ruby bindings to the [GNU MPC](http://www.multiprecision.org/) library.

Methods
=======

"Initialization" Methods
------------------------

```ruby
MPC.new(7)      # (7,0)
MPC.new(7, 32)  # (7,0) with precision 32
MPC#prec        # precision if real and imag precisions are the same, 0 otherwise
MPC#prec2       # real and imaginary precisions, as a 2-element Array
MPC#prec=       # set precision
MPC#set_prec(precision, rounding_mode) # set precision
```

Projection and Decomposing Methods
----------------------------------

```ruby
MPC#real   # real part
MPC#imag   # imaginary part
MPC#arg    # argument
MPC#proj   # projection
```

Basic Arithmetic Methods
------------------------

```ruby
MPC#add(w)    # add with w
MPC#sub(w)    # difference with w
MPC#mul(w)    # multiply with w
MPC#div(w)    # divide by w
MPC#fma(w,x)  # multiple by w, then add with x
```

Power and Logarithm Methods
---------------------------

```ruby
MPC#sqrt      # square root
MPC#pow(w)    # raise to the power w
MPC#** w      # raise to the power w
MPC#exp       # exponential
MPC#log       # natural logarithm
MPC#log10     # base-10 logarithm
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

Miscellaneous Functions
-----------------------

```ruby
GMP::RandState#mpc_urandom  # uniformly distributed random complex number within
                            # [0,1] x [0,1]
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

Manual
======

There is also a PDF [manual](manual.pdf) in addition to this readme.
