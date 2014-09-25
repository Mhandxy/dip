function FS = fourierspectrum(varargin)
narginchk(1,3);
img=varargin{1};
if nargin == 3  
    m=varargin{2};
    n=varargin{3};
else
    [m,n]=size(img(:,:,1));
end
%SFS=log(1+abs(fftshift(fft2(img(:,:,1),m,n))));
SFS=abs(fftshift(fft2(img(:,:,1),m,n)));
SFS=log(1+SFS)/log(10);
fsmin=min(min(SFS));
fsmax=max(max(SFS));
FS=zeros(m,n,3);
FS(:,:,1)=floor((SFS-fsmin)/(fsmax-fsmin)*255);
FS(:,:,2)=FS(:,:,1);
FS(:,:,3)=FS(:,:,1);
FS=uint8(FS);
