clc;
clear all;
% BK_BuildLib; disp('BuildLib PASSED');
% BK_LoadLib;  disp('LoadLib PASSED');

unary = [9 7 5;
         4 7 8];
% pair: i j e00 e01 e10 e11
% pair = [1 2 0 2 3 0;
%         2 3 0 1 5 0; ];
pair = [1 2 0 2 3 0;
        2 3 0 1 5 0; ];

h = BK_Create(3);
BK_SetUnary(h, unary);
BK_SetPairwise(h, pair);
e = BK_Minimize(h);
labeling = BK_GetLabeling(h);

BK_Delete(h);