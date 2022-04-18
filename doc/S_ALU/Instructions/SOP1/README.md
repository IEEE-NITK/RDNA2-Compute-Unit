# Scalar

### S_MOV_B64

Move data to an SGPR.

D.u = S0.u.

```verilog
S_MOV_B64: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = r0;
                en_64 = 1;
                en_w=1;
                end
```
