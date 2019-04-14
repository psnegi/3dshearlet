%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function F= GetMeyerBasedFilter(level,dBand,dataClass)
% Generates windowing filters
%Input:   
%        level      : In multilevel decomposition number of level
%        dataClass  : 'single' or 'double'
%Output: 
%        F          : Windowing filter at different level
%                   : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function F= GetMeyerBasedFilter(level,dBand,filterSize,dataClass)

F=cell(3,level);  

for l=1:level  

cubeSize=filterSize(l);

numDir=dBand{level}{l}(1,1);
  
[P,PF]=GeneratePyramidSection(cubeSize);
SF=PF{1}+PF{2}+PF{3};
PF{1}=SF;
PF{2}=SF;
PF{3}=SF;
shift=floor(cubeSize/numDir);
F{3,l}=cell(numDir,numDir);
  
A=zeros(cubeSize,cubeSize,cubeSize,dataClass);
  
for c=1:3
% building meyer filer in 3-d radial grid
% Think of it as 3-d rectangle. Middle radial, coordiantes goes along the length.
% center have response 1.
% as one moves away from the center, filter response decreases(check meyer filter description) 
	mRadial=ones(shift+1,cubeSize,shift+1,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift+1])=.5;  
  mRadial(1,1: cubeSize,1)=1/3;

  l2=1;
  l1=1;
  
  % mRadialIdx specifies radial region boundary for filter with orientation l1, l2
  % l1 controls first (i) radial coordinates and l2 controls third (j) coordinates
  mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1  ];

  
  F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
  A=A+F{c,l}{l2,l1};

  mRadial=ones(shift+1,cubeSize,shift+1,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift+1])=.5;  

   for l2=2:numDir-1
    for l1=2:numDir-1
      mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1  ];
      
      F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
      A=A+F{c,l}{l2,l1};
    end
   end 
   
  mRadial=ones(shift,cubeSize,shift+1,dataClass);
  mRadial( [1 shift],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift,1: cubeSize,[1 shift+1])=.5;
  mRadial(shift,1: cubeSize,1)=1/3;
  
  l2=1;
  l1=numDir;
  mRadialIdx=[(l1-1)*shift+1  l1*shift ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1  ];

  F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
    A=A+F{c,l}{l2,l1};
   
  mRadial=ones(shift,cubeSize,shift+1,dataClass);
  mRadial( [1 shift],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift,1: cubeSize,[1 shift+1])=.5;
  
  for l2=2:numDir-1
     l1=numDir;
      mRadialIdx=[(l1-1)*shift+1  l1*shift ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1  ];
      
      F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
      A=A+F{c,l}{l2,l1};
  end
  mRadial=ones(shift+1,cubeSize,shift+1,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift+1])=.5; 
  for l2=2:numDir-1
     l1=1;
      mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1  ];
      
      F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
      A=A+F{c,l}{l2,l1};
   end 
     
  mRadial=ones(shift+1,cubeSize,shift,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift])=.5;
  mRadial(1,1: cubeSize,shift)=1/3;
    
  l1=1;
  l2=numDir;
  mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift ];
      
  F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
  A=A+F{c,l}{l2,l1};
   
  mRadial=ones(shift+1,cubeSize,shift,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift])=.5;
   
  for l1=2:numDir-1
    l2=numDir;
    mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift ];

    F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
    A=A+F{c,l}{l2,l1};
  end
  mRadial=ones(shift+1,cubeSize,shift+1,dataClass);
  mRadial( [1 shift+1],1:cubeSize,1: shift+1)=.5;
  mRadial(1: shift+1,1: cubeSize,[1 shift+1])=.5;
   
  for l1=2:numDir-1
  l2=1;
     mRadialIdx=[(l1-1)*shift+1  l1*shift+1 ;1 cubeSize ; (l2-1)*shift+1  l2*shift+1 ];
      
      F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
      A=A+F{c,l}{l2,l1};
  end
   
  mRadial=ones(shift,cubeSize,shift,dataClass);
  mRadial( [1 shift],1:cubeSize,1: shift)=.5;
  mRadial(1: shift,1: cubeSize,[1 shift])=.5;
  mRadial( shift,1: cubeSize,shift)=1/3;
  l1=numDir;
  l2=numDir;
  mRadialIdx=[(l1-1)*shift+1  l1*shift ;1 cubeSize ; (l2-1)*shift+1  l2*shift ];
      
  F{c,l}{l2,l1}=PolarToRec(mRadialIdx,mRadial,cubeSize,P{c},PF{c} );
  A=A+F{c,l}{l2,l1};
end
  
for c=1:3
   for l2=1:numDir
     for l1=1:numDir
       F{c,l}{l2,l1}=F{c,l}{l2,l1}./A;
        F{c,l}{l2,l1}=squeeze(real(fftshift(ifftn(fftshift(F{c,l}{l2,l1})))));      
     end
   end
end
end
Temp=F(1,:);
F(1,:)=F(2,:);
F(2,:)=Temp;

