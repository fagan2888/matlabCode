R = 6;% num eqnsC = 3; % num top units.A = rand(R,C);x1 = rand(C,1);y1 = A*x1;xx1 = jsimsolve(A,y1);% Now do bias% Append column of ones to A.temp = ones(R,1);B = [A,temp];% Append row of bias to x1.bias1 = 0.1;xx1 = [x1;bias1];% Get yy with bias.yy1 = B*xx1;% ADD NOISE to get least sq solution.noise = 0.5;yy1 = yy1 + noise*rand(R,1);% OK - now do [x1_sol b1_sol]=jaffinesolve(A,yy1);% [x1_sol]=jsimsolve(A,y1);xx1x1_sol'b1_sol% Next 2 should be equal ... if no noise added above.A*x1_sol' + b1_solyy1sum(abs(A*x1_sol' + b1_sol-yy1))/Rreturn;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% And for solution to many sets of eqns...bias2=0.0;x2 = rand(C,1);y2 = A*x2;xx2 = [x2;bias2];yy2 = B*xx2;[x2_sol b2_sol]=jaffinesolve(A,yy2);xx2x2_solb2_solyy3 = [yy1,yy2];[x3_sol b3_sol]=jaffinesolve(A,yy3);yy3x3_solb3_sol