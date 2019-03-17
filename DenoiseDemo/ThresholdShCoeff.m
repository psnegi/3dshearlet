function shCoeff=ThresholdShCoeff(shCoeff,dstScalars,pyrCone,sigma,thr)
level = length(shCoeff);
for l = 1:level
  [sizel2,sizel1] =size(shCoeff{l});
  for l2 =1:sizel2
    for l1 =1:sizel1      
	      shCoeff{l}{l2,l1}(abs(shCoeff{l}{l2,l1}) <=thr(l)*sigma*dstScalars.bandEst{pyrCone,l}(l2,l1))=0;      
    end
  end
end  
