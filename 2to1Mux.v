//S - Select | D0,D1 - Input
module mux2to1(
Y, D0, D1, S
);


output Y;
input D0, D1, S;
wire T1, T2,SBar;

and (T1, D1, S), (T2,D0,SBar);
not (SBar, S);
or (Y, T1, T2);

endmodule 