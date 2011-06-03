# -*- coding: utf-8 -*-

import string

def patternFromPaths( path_a, path_b):
   path = path_a

   len_a = len(path_a)
   len_b = len(path_b)
   len_min = len_a
   if len_min > len_b: len_min = len_b
   if len_min < 1: return path

   len_begin = -1
   for c in range( len_min):
      if path_a[c] == path_b[c]: continue
      len_begin = c
      break
   if len_begin < 1: return path

   len_end = -1
   for c in range( len_min):
      if path_a[len_a-c-1] == path_b[len_b-c-1]: continue
      len_end = c
      break
   if len_end < 1: return path

   for c in range( len_begin):
      if path_a[len_begin-c] in string.digits: continue
      len_begin = len_begin - c + 1
      break

   for c in range( len_end):
      if path_a[len_a-len_end+c] in string.digits: continue
      len_end = len_end - c
      break

   padding = 1
   if len_a == len_b:
      padding = len_a - len_begin - len_end
   
   path = path_a[0:len_begin] + '@' + '#'*padding + '@' + path_a[len_a-len_end:len_a]

   return path

def patternFromStdC( path, verbose = False):
   pos = 0
   while pos < len(path):
      posp = path[pos:].find('%')
      if posp == -1: return path
      posd = path[pos+posp:].find('d')
      if posd == -1: return path
      pattern = None
      if posd == 1:
         pattern = '@#@'
      else:
         digits = path[pos+posp+1:pos+posp+posd]
         if verbose: print 'digits = "%s"' % digits
         digits_ok = True
         for d in digits:
            if d not in string.digits:
               digits_ok = False
               break
         if digits_ok:
            number = int(digits)
            pattern = '@' + '#'*number + '@'
            if verbose: print 'number = %d' % number
      if pattern is not None:
         if verbose: print 'pattern = "%s"' % pattern
         path = path[:pos+posp] + pattern + path[pos+posp+posd+1:]
         pos = pos+posp + len(pattern)
      else:
         if verbose: print 'No pattern.'
         pos += posp+posd
   return paths

def patternFromDigits( path, verbose = False):
   pos = 0
   posd = 0
   while pos < len(path):
      posd = path[pos:].find('#')
      if posd == -1: break
      # Check if it is an already formatted pattern:
      if pos+posd > 0 and path[pos+posd-1] == '@':
         cab = path[pos+posd:].find('@')
         if cab != -1:
            # Shift and continue:
            pos = pos+posd+cab
            continue
      posd += pos
      pos = posd
      # Shift to the last #:
      for d in path[posd:]:
         if d != '#': break
         pos += 1
      if verbose: print 'path[%d:%d] = "%s"' % (posd, pos, path[posd:pos])
      path = path[:posd] + '@' + path[posd:pos] + '@' + path[pos:]
      pos += 2
   return path
