@osc1 = control_osc(:amp => 60, :freq => 0.1, :shape => :sin, :tick => 0.1){ |i| puts i}
@osc1.go

@osc1.stop

@osc2 = control_osc(:amp => 60, :freq => 0.1, :shape => :cos, :tick => 0.1){|i| puts i}
@osc2.go

@osc2.stop

@osc3 = control_osc(:amp => 60, :freq => 0.1, :shape => :triangle, :tick => 0.1){|i| puts i}
@osc3.go

@osc3.stop

@osc4 = control_osc(:amp => 60, :freq => 0.1, :shape => :saw, :tick => 0.1){|i| puts i}
@osc4.go

@osc4.stop

@osc5 = control_osc(:amp => 60, :freq => 0.1, :shape => :square, :tick => 0.1){|i| puts i}
@osc5.go

@osc5.stop

exit
