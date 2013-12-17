#!/usr/bin/env ruby

require 'mkmf'

dir_config('mpc')

ok = true

unless have_header('gmp.h')
  $stderr.puts "can't find gmp.h, try --with-gmp-include=<path>"
  ok = false
end

unless have_library('gmp', '__gmpz_init')
  $stderr.puts "can't find -lgmp, try --with-gmp-lib=<path>"
  ok = false
end

unless (have_header('mpfr.h') and
    have_header('mpf2mpfr.h') and
    have_library('mpfr', 'mpfr_init'))
  ok = false
end
$CFLAGS += ' -DMPFR'

unless have_header('mpc.h')
  $stderr.puts "can't find mpc.h, try --with-mpc-include=<path>"
  ok = false
end

unless have_library('mpc', 'mpc_init2')
  $stderr.puts "can't find -lmpc, try --with-mpc-lib=<path>"
  ok = false
end

unless have_macro('SIZEOF_INTPTR_T')
  check_sizeof('intptr_t')
end

if try_compile('', '-O6')
  $CFLAGS += ' -Wall -W -O6 -g'
else
  $CFLAGS += ' -Wall -W -O3 -g'
end

if not ok
  raise "Unable to build, correct above errors and rerun"
end

create_makefile('mpc')
