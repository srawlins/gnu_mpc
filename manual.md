<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<style>
body {
  width: 800px;
}

table {
  border-collapse: collapse;
  border-top: solid 2px black;
}

th {
  font-weight: normal;
  text-align: right;
  white-space: nowrap;
}

th:first-child {
  text-align: left;
}

tr.last-header th {
  border-bottom: solid 1px black;
}

tr.last-header th:first-child {
  border-bottom: 0;
}
</style>

# GNU MPC

Ruby bindings to the GNU MPC library

Edition 0.1.1

3 October 2012

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

    gem install mpc

At this time, the gem self-compiles. If required libraries cannot be found, you may
compile the C extensions manually with:

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

\newpage

## Complex Functions

### Initializing, Assigning Complex Numbers

\begin{tabular}{p{\methwidth} l r}
\toprule
\textbf{new} & & MPC.new $\rightarrow$ \textit{integer} \\
& & MPC.new(\textit{numeric = 0}) $\rightarrow$ \textit{integer} \\
& & MPC.new(\textit{str}, \textit{base = 0}) $\rightarrow$ \textit{integer} \\
\cmidrule(r){2-3}
& \multicolumn{2}{p{\defnwidth}}{
  This method creates a new `MPC` integer. It typically takes one optional argument for
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
  <tr>
    <th>new</th><th></th><th>`MPC.new` $\rightarrow$ _integer_
  </tr>
  <tr>
    <th></th>   <th></th><th><code>MPC.new(<em>numeric=0</em>)</code> $\rightarrow$ _integer_
  <tr class='last-header'>
    <th></th>   <th></th><th><code>MPC.new(<em>string</em>)</code> $\rightarrow$ _integer_
  </tr>
  <tr>
    <td></td>
    <td colspan="2">
      This method creates a new `MPC.new` integer. It typically takes one optional
argument for the value of the integer. This argument can be one of several
classes. If the first argument is a String, then a second argument, the base,
may be optionally supplied. Here are some examples:

<pre><code>
MPC.new                  #=> 0 (default)
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

### Basic Arithmetic

### Power Functions and Logarithm

\begin{tabular}{p{\methwidth} l r}
\toprule
\textbf{sqrt} & & MPC\#sqrt $\rightarrow$ \textit{complex} \\
& & MPC\#sqrt(\textit{rounding\_mode}) $\rightarrow$ \textit{complex} \\
& & MPC\#sqrt(\textit{rounding\_mode}, \textit{precision}) $\rightarrow$ \textit{complex} \\
\cmidrule(r){2-3}
& \multicolumn{2}{p{\defnwidth}}{
  Return the square root of the receiver, rounded according to $rounding\_mode$.
  The returned value has a non-negative real part, and if its real part is
  zero, a non-negative imaginary part.
}
\end{tabular}

\ifdef{HTML}
<table>
  <tr>
    <th>sqrt</th><th></th><th>`MPC#sqrt` $\rightarrow$ _complex_
  </tr>
  <tr>
    <th></th>   <th></th><th><code>MPC#sqrt(<em>rounding_mode</em>)</code> $\rightarrow$ _complex_
  <tr class='last-header'>
    <th></th>   <th></th><th><code>MPC#sqrt(<em>rounding_mode</em>, <em>precision</em>)</code> $\rightarrow$ _complex_
  </tr>
  <tr>
    <td></td>
    <td colspan="2">
  Return the square root of the receiver, rounded according to $rounding\_mode$.
  The returned value has a non-negative real part, and if its real part is
  zero, a non-negative imaginary part.
    </td>
  </tr>
</table>
\endif

### Trigonometric Functions

### Miscellaneous Complex Functions

### Advanced Functions

### Internals
