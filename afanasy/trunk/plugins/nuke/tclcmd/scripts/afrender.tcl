proc afrender {args} {
   set nameaf [lindex $args 0]
   set writer [input $nameaf 0]
   set namewrite [knob $writer.name]
   if {[class $writer] != "Write"} {
      alert "Node class $namewrite is not Write"
      return}
   if {[knob $writer.disable] == true} {
      alert "Node $namewrite is disabled"
      return}
   set images [knob $writer.file]

   set first         [lindex $args  1]
   set last          [lindex $args  2]
   set inc           [lindex $args  3]
   set fpr           [lindex $args  4]
   set startpaused   [lindex $args  5]
   set priority      [lindex $args  6]
   set maxhosts      [lindex $args  7]
   set hostsmask     [lindex $args  8]
   set hostsexcl     [lindex $args  9]
   set dependmask    [lindex $args 10]
   set dependglbl    [lindex $args 11]
   set jobname       [lindex $args 12]
   set capacity      [lindex $args 13]
   set capmin        [lindex $args 14]
   set capmax        [lindex $args 15]
   set platform      [lindex $args 16]

   if {$first > $last} {
      alert "First frame > Last frame"
      return}
   if {$fpr < 1} {
      alert "Frames per render - must be > 0"
      return}

   set changed [modified]
   set namesc [knob root.name]
   set namesctmp $namesc
   set namesc [regsub {.*/} $namesc ""]
   if {[knob root.name] == ""} {
      set namesctmp "tmp."
   }
   append namesctmp [clock format [clock seconds] -format %d-%m-%Y.%H-%M.[string range [clock clicks] 3 6]]
   append namesctmp \.nk
   script_save $namesctmp
   modified $changed

   if { $jobname == ""} {
      set jobname $namesc
   }

   regsub -all "\\\\" $namesctmp "/" namesctmp

   set cmd [getenv AF_ROOT]
   set cmd [file join $cmd "python"]
   set cmd [file join $cmd "afjob.py"]
   set cmd "python $cmd"
   append cmd " $namesctmp $first $last -fpr $fpr -by $inc -node $namewrite -name \"$jobname\" -images \"$images\" -deletescene"

   if { $startpaused      } { append cmd " -pause"                      }
   if { $platform == "Any"} { append cmd " -os any"                     }
   if { $maxhosts   != -1 } { append cmd " -maxhosts $maxhosts"         }
   if { $priority   != -1 } { append cmd " -priority $priority"         }
   if { $capacity   != -1 } { append cmd " -capacity $capacity"         }
   if { $capmin     != -1 } { append cmd " -capmin $capmin"             }
   if { $capmax     != -1 } { append cmd " -capmax $capmax"             }
   if { $hostsmask  != "" } { append cmd " -hostsmask \"$hostsmask\""   }
   if { $hostsexcl  != "" } { append cmd " -hostsexcl \"$hostsexcl\""   }
   if { $dependmask != "" } { append cmd " -depmask \"$dependmask\""    }
   if { $dependglbl != "" } { append cmd " -depglbl \"$dependglbl\""    }

   puts $cmd
   eval exec $cmd
}
