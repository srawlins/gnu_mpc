<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<style>
body {
  margin: 0 auto;
  width: 800px;
}

table {
  border-collapse: collapse;
  width:96%;
}

th {
  font-weight: normal;
  text-align: right;
  white-space: nowrap;
}

tr.new-method th {
  border-top: solid 2px black;
}

th:first-child {
  text-align: left;
  width: 0.8in;
}

tr.last-header th {
  border-bottom: solid 1px black;
}

tr.last-header th:first-child {
  border-bottom: 0;
}

td:last-child {
  padding-bottom: 1em;
}

pre {
  background-color: #EEEEEE;
  padding: 3px 2px;
</style>

# GNU MPC

Ruby bindings to the GNU MPC library

Edition 0.1.1

9 October 2012

\vfill

written by Sam Rawlins

with extensive quoting from the GNU MPC manual

\newpage

\vfill

This manual describes how to use the gnu\_mpc Ruby gem, which provides bindings
to GNU MPC, "a C library for the arithmetic of complex numbers with arbitrarily
high precision and correct rounding of the result."

Copyright 2012 Sam Rawlins

Apache 2.0 License [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

\newpage

\tableofcontents

\newpage








## Introduction to GNU MPC

GNU MPC is a C library for the arithmetic of complex numbers with arbitrarily
high precision and correct rounding of the result. It extends the principles of
the IEEE-754 standard for fixed precision real floating point numbers to
complex numbers, providing well-defined semantics for every operation. At the
same time, speed of operation at high precision is a major design goal.

The library is built upon and follows the same principles as Gnu Mpfr. It is
written by Andreas Enge, Mickaël Gastineau, Philippe Théveny and Paul
Zimmermann and is distributed under the Gnu Lesser General Public License,
either version 3 of the licence, or (at your option) any later version. The Gnu
Mpc library has been registered in France by the Agence pour la Protection des
Programmes on 2003-02-05 under the number IDDN FR 001 060029 000 R P 2003 000
10000.

\newpage








## Introduction to the gnu\_mpc gem

The gnu\_gmp Ruby gem is a Ruby library that provides bindings to GNU MPC. The
gem is incomplete, and will likely only include a subset of the GMP functions.
It is built as a C extension for Ruby, interacting with mpc.h. The gnu\_mpc gem
is not endorsed or supported by GNU or the MPC team. The gnu\_mpc gem also does
not ship with MPC; that must be compiled separately.








## Installing the gnu\_mpc gem

### Prerequisites

OK. First, we've got a few requirements. To install the gnu\_mpc gem, you need
one of the following versions of Ruby:

* (MRI) Ruby 1.8.7 - tested seriously.
* (MRI) Ruby 1.9.3 - tested seriously.
* (REE) Ruby 1.8.7 - tested lightly.
* (RBX) Rubinius 1.1 - tested lightly.

As you can see, only Matz's Ruby Interpreter (MRI) is seriously supported.

Next is the platform, the combination of the architecture (processor) and OS.
As far as I can tell, if you can compile MPC and Ruby on a given platform, you
can use the mpc gem there too. Please report problems with that hypothesis.

Lastly, MPC. MPC must be compiled and working. "And working" means
you ran `make check` after compiling MPC, and it 'check's out. The following
version of MPC have been tested:

* MPC 1.0.1

That's all. I don't intend to test any older versions.

### Installing

You may clone the mpc gem's git repository with:

    git clone git://github.com/srawlins/gnu_mpc.git

Or you may install the gem from <http://rubygems.org>:

    gem install gnu_mpc

At this time, the gem self-compiles. If required libraries cannot be found, you
may compile the C extensions manually with:

    cd <gnu_mpc gem directory>/ext
    ruby extconf.rb
    make

There shouldn't be any errors, or warnings.








## Testing the gnu\_mpc gem

Testing the gnu\_mpc gem is quite simple. The testing framework uses RSpec.

    bundle && rspec








## MPC and mpc gem basics

### Classes

The gnu\_mpc gem includes the class `MPC`. There are also some constants within
`MPC`:

`MPC::MPC_VERSION` - The version of MPC linked into the mpc gem

`MPC::MPC_RNDxy` - Rounding mode where $x$ is the rounding mode for the real
part and $y$ is the rounding mode for the imaginary part.

<!--\newpage-->

### Standard Options Hash Keys

Unless otherwise noted, each `MPC` instance method will accept an options hash
for optional arguments, after any required arguments. For example, since
`MPC#pow` requires one argument but `MPC#sin` requires none, options hashes can
be supplied like so:

    MPC.new([1,1]).pow(2, {})
    MPC.new([1,1]).sin({})

Here are the keys typically accepted by an `MPC` instance method.

`:rnd`, `:round`, `:rounding`, `:rounding_mode`
:   rounding mode for the operation
`:prec`, `:precision`
:   precision used when initializing the return value; This precision will be
    used for both the real and imaginary parts of the returned complex value.
`:real_prec`, `:real_precision`
:   precision used for the real part of the return value
`:imag_prec`, `:imag_precision`
:   precision used for the imaginary part of the return value

### Precision of Returned Values

Unless otherwise noted, the precision of a value returned by an `MPC` instance
method follows certain standards. By default, a method will create and return
an object with the MPFR default precision (which can be changed with
`GMP::F.default_prec=`). The user can also pass in a preferred precision in one
of three ways:

* Most methods will accept a `precision` parameter in their ordered argument
  list, which will be used for both the real and imaginary parts of the return
  object.
* Most methods accept an options hash as well. The user can pass in a perferred
  precision using the `:prec` or `:precision` keys, like so:

        MPC.new(5).sin(:prec => 64)
        MPC.new([7,11]).exp(:precision => 128)

* The user can also specify the precision of the real part, and the imaginary
  part, individually, using the options hash as well. The `:real_prec`,
  (or `:real_precision`) and `:imag_prec` (or `:imag_precision`) keys can be
  used:

        MPC.new(72).sin(:real_prec => 17, :imag_prec => 53)
  The broad `:prec` and `:precision` values are parsed before the real- and
  imaginary-specific values, so that

        my_usual_options = {:rounding => MPC::MPC_RNDZZ, :prec => 64}
        MPC.new(42).tan(my_usual_options.merge(:prec_real => 128))
  will return the tangent of 42 with a precision of 64 on the real part and a
  precision of 128 on the imaginary part.








## Complex Functions

### Initializing, Assigning Complex Numbers

\begin{tabular}{p{\methwidth} l r}
\toprule
\textbf{new} & & MPC.new $\rightarrow$ \textit{integer} \\
& & MPC.new(\textit{numeric = 0}) $\rightarrow$ \textit{integer} \\
& & MPC.new(\textit{str}, \textit{base = 0}) $\rightarrow$ \textit{integer} \\
\cmidrule(r){2-3}
& \multicolumn{2}{p{\defnwidth}}{
  This method creates a new \texttt{MPC} integer. It typically takes one optional argument for
  the value of the integer. This argument can be one of several classes. If the first
  argument is a String, then a second argument, the base, may be optionally supplied.
  Here are some examples:\newline

  \texttt{MPC.new \qqqquad\qqqquad \#=> 0 (default) \newline
          MPC.new(1) \qqqquad\qquad\  \#=> 1 (Ruby Fixnum) \newline
          MPC.new("127") \qqqquad\  \#=> 127 (Ruby String)\newline
          MPC.new("FF", 16) \qquad\ \  \#=> 255 (Ruby String with base)\newline
          MPC.new("1Z", 36) \qquad\ \  \#=> 71 (Ruby String with base)\newline
          MPC.new(4294967296) \qquad \#=> 4294967296 (Ruby Bignum)\newline
          MPC.new(GMP::Z.new(31))  \#=> 31 (GMP Integer)}
}
\end{tabular}

\ifdef{HTML}
<table>
  <tr class='new-method'>
    <th>new</th><th>`MPC.new` $\rightarrow$ _integer_</th>
  </tr>
  <tr>
    <th></th>   <th><code>MPC.new(<em>numeric=0</em>)</code> $\rightarrow$ _integer_</th>
  </tr>
  <tr class='last-header'>
    <th></th>   <th><code>MPC.new(<em>string</em>)</code> $\rightarrow$ _integer_</th>
  </tr>
  <tr>
    <td></td>
    <td>
      This method creates a new `MPC.new` integer. It typically takes one optional
argument for the value of the integer. This argument can be one of several
classes. If the first argument is a String, then a second argument, the base,
may be optionally supplied. Here are some examples:

<pre><code>MPC.new                  #=> 0 (default)
MPC.new(1)               #=> 1 (Ruby Fixnum)
MPC.new("127")           #=> 127 (Ruby String)
MPC.new("FF", 16)        #=> 255 (Ruby String with base)
MPC.new("1Z", 36)        #=> 71 (Ruby String with base)
MPC.new(4294967296)      #=> 4294967296 (Ruby Bignum)
MPC.new(GMP::Z.new(31))  #=> 31 (GMP Integer)
</code></pre>
    </td>
  </tr>
</table>
\endif








### Converting Complex Numbers








### String and Stream Input and Output








### Complex Comparison








### Projection and Decomposing

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{real} & & MPC\#real() & $\rightarrow$ \textit{GMP::F} \\
& & MPC\#real(\textit{rounding\_mode} = MPC::MPC\_RNDNN) & $\rightarrow$ \textit{GMP::F} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the real part of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{imag} & & MPC\#imag() & $\rightarrow$ \textit{GMP::F} \\
& & MPC\#imag(\textit{rounding\_mode} = MPC::MPC\_RNDNN) & $\rightarrow$ \textit{GMP::F} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the imaginary part of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{proj} & & MPC\#proj() & $\rightarrow$ \textit{GMP::F} \\
& & MPC\#proj(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{GMP::F} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the projection of the receiver onto the Riemann sphere, rounded according to
  $rounding\_mode$.
} \\
\end{tabular}

\ifdef{HTML}
<table>
  <tr class="new-method">
    <th>real</th><th>`MPC#real()` $\rightarrow$ _GMP::F_
  </tr>
  <tr class="last-header">
    <th></th>   <th><code>MPC#real(_rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _GMP::F_
</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the real part of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method">
    <th>imag</th><th>`MPC#imag()` $\rightarrow$ _GMP::F_
  </tr>
  <tr class="last-header">
    <th></th>   <th><code>MPC#imag(_rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _GMP::F_
</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the imaginary part of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method">
    <th>proj</th><th>`MPC#proj()` $\rightarrow$ _GMP::F_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#proj(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _GMP::F_
</th>
  </tr>
  <tr class="last-header">
    <th></th>   <th>`MPC#proj(options_hash)` $\rightarrow$ _complex_</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the projection of the receiver onto the Riemann sphere, rounded
according to $rounding\_mode$.
    </td>
  </tr>
</table>
\endif








### Basic Arithmetic

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{add, +} & & MPC\#add($op2$) & $\rightarrow complex$ \\
& & MPC\#add($op2$, $rounding\_mode$ = MPC::MPC\_RNDNN) & $\rightarrow complex$ \\
& & $op1 + op2$ & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the sum of the receiver ($op1$) and $op2$, rounded according to
  $rounding\_mode$. $op2$ may be a \texttt{Fixnum}, \texttt{GMP::Z}, \texttt{Bignum}, or \texttt{GMP::F}.\newline

  \texttt{a = MPC.new(GMP::F("3.1416", 12)) \#=> (3.1416 +0) \newline
          a + 0 \qqqquad\qqqquad\qquad\qqqquad \#=> (3.1416 +0) \newline
          a + 1 \qqqquad\qqqquad\qqqquad\qquad \#=> (4.1406 +0) \newline
          a - -7 \qqqquad\qqqquad\qqqquad\quad\  \#=> (-3.8584 +0) \newline
          a + GMP::Z(1024) \qqqquad\qqqquad\  \#=> (1.0270e+3 +0) \newline
          a + 2**66 \qqqquad\qqqquad\qqqquad \#=> (7.3787e+19 +0) \newline
          a + GMP::F("3.1416", 12) \qqqquad\  \#=> (6.2832 +0) \newline}
} \\

\toprule
\textbf{sub, -} & & MPC\#sub($op2$) & $\rightarrow complex$ \\
& & MPC\#sub($op2$, $rounding\_mode$ = MPC::MPC\_RNDNN) & $\rightarrow complex$ \\
& & $op1 - op2$ & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the difference between the receiver ($op1$) and $op2$, rounded according to
  $rounding\_mode$. $op2$ may be a \texttt{Fixnum}, \texttt{GMP::Z}, \texttt{Bignum}, or \texttt{GMP::F}.\newline

  \texttt{a = MPC.new(GMP::F("3.1416", 12)) \#=> (3.1416 +0) \newline
          a - 0 \qqqquad\qqqquad\qquad\qqqquad \#=> (3.1416 +0) \newline
          a - 1 \qqqquad\qqqquad\qqqquad\qquad \#=> (2.1416 +0) \newline
          a - -7 \qqqquad\qqqquad\qqqquad\quad\  \#=> (1.0141e+1 +0) \newline
          a - GMP::Z(1024) \qqqquad\qqqquad\  \#=> (-1.0208e+3 +0) \newline
          a - 2**66 \qqqquad\qqqquad\qqqquad \#=> (-7.3787e+19 +0) \newline
          a - GMP::F("3.1416", 12) \qqqquad\  \#=> (+0 +0) \newline}
} \\

\toprule
\textbf{mul, *} & & MPC\#mul($op2$) & $\rightarrow complex$ \\
& & MPC\#mul($op2$, $rounding\_mode$ = MPC::MPC\_RNDNN) & $\rightarrow complex$ \\
& & $op1 * op2$ & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the product of the receiver ($op1$) and $op2$, rounded according to
  $rounding\_mode$. $op2$ may be a \texttt{Fixnum}, \texttt{GMP::Z}, \texttt{Bignum}, or \texttt{GMP::F}.\newline

  \texttt{a = MPC.new(GMP::F("3.1416", 12)) \#=> (3.1416 +0) \newline
          a * 0 \qqqquad\qqqquad\qquad\qqqquad \#=> (+0 +0) \newline
          a * 1 \qqqquad\qqqquad\qqqquad\qquad \#=> (3.1416 +0) \newline
          a * -7 \qqqquad\qqqquad\qqqquad\quad\  \#=> (-2.1992e+1 -0)\newline
          a * GMP::Z(1024) \qqqquad\qqqquad\  \#=> (3.2170e+3 +0) \newline
          a * 2**66 \qqqquad\qqqquad\qqqquad \#=> (2.3181e+20 +0) \newline
          a * GMP::F("3.1416", 12) \qqqquad\  \#=> (9.8711 +0) \newline}
}
\end{tabular}

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{div, /} & & MPC\#div($op2$) & $\rightarrow complex$ \\
& & MPC\#div($op2$, $rounding\_mode$ = MPC::MPC\_RNDNN) & $\rightarrow complex$ \\
& & $op1 / op2$ & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the quotient of the receiver ($op1$) and $op2$, rounded according to
  $rounding\_mode$. $op2$ may be a \texttt{Fixnum}, \texttt{GMP::Z}, \texttt{Bignum}, or \texttt{GMP::F}.\newline

  \texttt{a = MPC.new(GMP::F("3.1416", 12)) \#=> (3.1416 +0) \newline
          a / 0 \qqqquad\qqqquad\qquad\qqqquad \#=> (@Inf@ @NaN@) \newline
          a / 1 \qqqquad\qqqquad\qqqquad\qquad \#=> (3.1416 +0) \newline
          a / -7 \qqqquad\qqqquad\qqqquad\quad\  \#=> (-4.4885e-1 -0)\newline
          a / GMP::Z(1024) \qqqquad\qqqquad\  \#=> (3.0680e-3 +0) \newline
          a / 2**66 \qqqquad\qqqquad\qqqquad \#=> (4.9088e-2 +0) \newline
          a / GMP::F("3.1416", 12) \qqqquad\  \#=> (1.0000 +0) \newline}
}
\end{tabular}

\ifdef{HTML}
<table>
  <tr class="new-method">
    <th>add, +</th><th>`MPC#add(op2)` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#add(_op2_, _rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>    <th>`op1 + op2` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
Return the sum of the receiver ($op1$) and $op2$, rounded according to
$rounding\_mode$.

<pre><code>a = MPC.new(GMP::F("3.1416", 12)) #=> (3.1416 +0)
a + 0                             #=> (3.1416 +0)
a + 1                             #=> (4.1406 +0)
a + -7                            #=> (-3.8584 +0)
a + GMP::Z(1024)                  #=> (1.0270e+3 +0)
a + 2**66                         #=> (7.3787e+19 +0)
a + GMP::F("3.1416", 12)          #=> (6.2832 +0)
</code></pre>
    </td>
  </tr>

  <tr class="new-method">
    <th>sub, -</th><th>`MPC#sub(op2)` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#sub(_op2_, _rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>    <th>`op1 - op2` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
Return the difference between the receiver ($op1$) and $op2$, rounded according to
$rounding\_mode$.

<pre><code>a = MPC.new(GMP::F("3.1416", 12)) #=> (3.1416 +0)
a - 0                             #=> (3.1416 +0)
a - 1                             #=> (2.1416 +0)
a - -7                            #=> (1.0141e+1 +0)
a - GMP::Z(1024)                  #=> (-1.0208e+3 +0)
a - 2**66                         #=> (-7.3787e+19 +0)
a - GMP::F("3.1416", 12)          #=> (+0 +0)
</code></pre>
    </td>
  </tr>

  <tr class="new-method">
    <th>mul, *</th><th>`MPC#mul(op2)` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#mul(_op2_, _rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>    <th>`op1 * op2` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
Return the product of the receiver ($op1$) and $op2$, rounded according to
$rounding\_mode$.

<pre><code>a = MPC.new(GMP::F("3.1416", 12)) #=> (3.1416 +0)
a * 0                             #=> (+0 +0)
a * 1                             #=> (3.1416 +0)
a * -7                            #=> (-2.1992e+1 -0)
a * GMP::Z(1024)                  #=> (3.2170e+3 +0)
a * 2**66                         #=> (2.3181e+20 +0)
a * GMP::F("3.1416", 12)          #=> (9.8711 +0)
</code></pre>
    </td>
  </tr>

  <tr class="new-method">
    <th>div, /</th><th>`MPC#div(op2)` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#div(_op2_, _rounding_mode_ = MPC::MPC_RNDNN)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>    <th>`op1 / op2` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
Return the quotient of the receiver ($op1$) and $op2$, rounded according to
$rounding\_mode$.

<pre><code>a = MPC.new(GMP::F("3.1416", 12)) #=> (3.1416 +0)
a / 0                             #=> (@Inf@ @NaN@)
a / 1                             #=> (3.1416 +0)
a / -7                            #=> (-4.4885e-1 -0)
a / GMP::Z(1024)                  #=> (3.0680e-3 +0)
a / 2**66                         #=> (4.9088e-2 +0)
a / GMP::F("3.1416", 12)          #=> (1.0000 +0)
</code></pre>
    </td>
  </tr>
</table>
\endif








### Power Functions and Logarithm

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{sqrt} & & MPC\#sqrt() & $\rightarrow$ \textit{complex} \\
& & MPC\#sqrt(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#sqrt(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the square root of the receiver, rounded according to
  $rounding\_mode$. The returned value has a non-negative real part, and if its
  real part is zero, a non-negative imaginary part.
} \\

\toprule
\textbf{pow} & & MPC\#pow() & $\rightarrow$ \textit{complex} \\
& \multicolumn{3}{p{\defnwidth}}{\textit{Not implemented yet.}} \\

\toprule
\textbf{exp} & & MPC\#exp() & $\rightarrow$ \textit{complex} \\
& & MPC\#exp(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#exp(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the exponential of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{log} & & MPC\#log() & $\rightarrow$ \textit{complex} \\
& & MPC\#log(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#log(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the natural logarithm of the receiver, rounded according to
  $rounding\_mode$. The principal branch is chosen, with the branch cut on the
  negative real axis, so that the imaginary part of the result lies in 
  $[-\pi, \pi]$ and $[-\pi/log(10), \pi/log(10)]$ respectively.
} \\

\toprule
\textbf{log10} & & MPC\#log10() & $\rightarrow$ \textit{complex} \\
& & MPC\#log10(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#log10(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the base-10 logarithm of the receiver, rounded according to
  $rounding\_mode$. The principal branch is chosen, with the branch cut on the
  negative real axis, so that the imaginary part of the result lies in 
  $[-\pi, \pi]$ and $[-\pi/log(10), \pi/log(10)]$ respectively.
}
\end{tabular}

\ifdef{HTML}
<table>
  <tr class="new-method">
    <th>sqrt</th><th>`MPC#sqrt()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#sqrt(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>   <th>`MPC#sqrt(options_hash)` $\rightarrow$ _complex_</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the square root of the receiver, rounded according to $rounding\_mode$.
The returned value has a non-negative real part, and if its real part is
zero, a non-negative imaginary part.
    </td>
  </tr>

  <tr class="new-method last-header">
    <th>pow</th><th>`MPC#pow()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
_Not implemented yet._
    </td>
  </tr>

  <tr class="new-method">
    <th>exp</th><th>`MPC#exp()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#exp(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>   <th>`MPC#exp(options_hash)` $\rightarrow$ _complex_</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the exponential of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method">
    <th>log</th><th>`MPC#log()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#log(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>   <th>`MPC#log(options_hash)` $\rightarrow$ _complex_</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the natural logarithm of the receiver, rounded according to
$rounding\_mode$. The principal branch is chosen, with the branch cut on the
negative real axis, so that the imaginary part of the result lies in 
$[-\pi, \pi]$ and $[-\pi/log(10), \pi/log(10)]$ respectively.
    </td>
  </tr>

  <tr class="new-method">
    <th>log10</th><th>`MPC#log()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th><code>MPC#log10(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_
</th>
  </tr>
  <tr class="last-header">
    <th></th>   <th>`MPC#log10(options_hash)` $\rightarrow$ _complex_</th>
  </tr>
  <tr>
    <td></td>
    <td>
Return the base-10 logarithm of the receiver, rounded according to
$rounding\_mode$. The principal branch is chosen, with the branch cut on the
negative real axis, so that the imaginary part of the result lies in 
$[-\pi, \pi]$ and $[-\pi/log(10), \pi/log(10)]$ respectively.
    </td>
  </tr>
</table>
\endif








### Trigonometric Functions

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{sin} & & MPC\#sin() & $\rightarrow$ \textit{complex} \\
& & MPC\#sin(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#sin(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the sine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{cos} & & MPC\#cos() & $\rightarrow$ \textit{complex} \\
& & MPC\#cos(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#cos(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the cosine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{sin\_cos} & & MPC\#sin\_cos() & $\rightarrow$ \textit{complex} \\
& \multicolumn{3}{p{\defnwidth}}{\textit{Not implemented yet.}} \\

\toprule
\textbf{tan} & & MPC\#tan() & $\rightarrow$ \textit{complex} \\
& & MPC\#tan(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#tan(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the tangent of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{sinh} & & MPC\#sinh() & $\rightarrow$ \textit{complex} \\
& & MPC\#sinh(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#sinh(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the hyperbolic sine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{cosh} & & MPC\#cosh() & $\rightarrow$ \textit{complex} \\
& & MPC\#cosh(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#cosh(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the hyperbolic cosine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{tanh} & & MPC\#tanh() & $\rightarrow$ \textit{complex} \\
& & MPC\#tanh(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow$ \textit{complex} \\
& & MPC\#tanh(\textit{options\_hash}) & $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the hyperbolic tangent of the receiver, rounded according to
  $rounding\_mode$.
}
\end{tabular}

\begin{tabular}{p{\methwidth} l r p{\returnwidth}}
\toprule
\textbf{asin} & & MPC\#asin() & $\rightarrow complex$ \\
& & MPC\#asin(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow complex$ \\
& & MPC\#asin(\textit{options\_hash}) & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the inverse sine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{acos} & & MPC\#acos() & $\rightarrow complex$ \\
& & MPC\#acos(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow complex$ \\
& & MPC\#acos(\textit{options\_hash}) & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the inverse cosine of the receiver, rounded according to
  $rounding\_mode$.
} \\

\toprule
\textbf{atan} & & MPC\#atan() & $\rightarrow complex$ \\
& & MPC\#atan(\textit{rounding\_mode} = MPC::MPC\_RNDNN, & \\
& & \textit{precision} = \textit{mpfr\_default\_precision}) & $\rightarrow complex$ \\
& & MPC\#atan(\textit{options\_hash}) & $\rightarrow complex$ \\
\cmidrule(r){2-4}
& \multicolumn{3}{p{\defnwidth}}{
  Return the inverse tangent of the receiver, rounded according to
  $rounding\_mode$.
}
\end{tabular}

\ifdef{HTML}
<table>
  <tr class="new-method"><th>sin</th><th>`MPC#sin()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#sin(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#sin(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the sine of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>cos</th><th>`MPC#cos()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#cos(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#cos(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the cosine of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method last-header">
    <th>sin_cos</th><th>`MPC#sin_cos()` $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td>
_Not implemented yet._
    </td>
  </tr>

  <tr class="new-method"><th>tan</th><th>`MPC#tan()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#tan(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#tan(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the tangent of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>sinh</th><th>`MPC#sinh()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#sinh(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#sinh(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the hyperbolic sine of the receiver, rounded according to
$rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>cosh</th><th>`MPC#cosh()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#cosh(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#cosh(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the hyperbolic cosine of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>tanh</th><th>`MPC#tanh()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#tanh(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#tanh(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the hyperbolic tangent of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>asin</th><th>`MPC#asin()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#asin(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#asin(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the inverse sine of the receiver, rounded according to
$rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>acos</th><th>`MPC#cosh()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#acos(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#acos(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the inverse cosine of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>

  <tr class="new-method"><th>atan</th><th>`MPC#atan()` $\rightarrow$ _complex_</tr>
  <tr><th></th>   <th><code>MPC#atan(_rounding_mode_ = MPC::MPC_RNDNN, _precision_ = _mpfr_default_)</code> $\rightarrow$ _complex_</th></tr>
  <tr class="last-header"><th></th>   <th>`MPC#atan(options_hash)` $\rightarrow$ _complex_</th></tr>
  <tr>
    <td></td><td>
Return the inverse tangent of the receiver, rounded according to $rounding\_mode$.
    </td>
  </tr>
</table>
\endif

### Miscellaneous Complex Functions

### Advanced Functions

### Internals
