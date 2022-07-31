parameter X = 4;  

input [X-1:0] onehot;
input i_data [X];
output reg o_data;

always_comb 
begin
   o_data = 'z;
   for(int i = 0; i < X; i++) begin
      if (onehot == (1 << i))
         o_data = i_data[i];
   end
end