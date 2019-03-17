function dstScalars = NsstScalars(sizeData,F,dataClass)
noise=randn(sizeData(1),sizeData(2),sizeData(3),dataClass);
level=size(F,2);
noiseBP=DoPyrDec(noise,level);
dstScalars.bandEst=cell(3,level);
dstNoise=noiseBP{level+1};
dstScalars.lowPassEst=median(abs(dstNoise(:) - median(dstNoise(:))))/.6745;
for pyrCone = 1:3
  for l=1:level
  [sizel1,sizel2]=size(F{pyrCone,l});
  dstScalars.bandEst{pyrCone,l}=zeros(sizel1,sizel2,dataClass);
    for l2=1:sizel2,
      for l1=1:sizel1
	       dstNoise=convnfft(noiseBP{l},F{pyrCone,l}{l2,l1},'same');
        dstScalars.bandEst{pyrCone,l}(l2,l1)=median(abs(dstNoise(:) - median(dstNoise(:))))/.6745;
      end
    end
  end
end 
