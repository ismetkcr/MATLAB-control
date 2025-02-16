% SMOOTH Simple gaussian smooth function
% vector = input vector
% width = width of the smoothing
% window = width of the window to be used in the convolution
 

function smoothedVector = smooth(vector, width, window)


if nargin < 2,
    width = 30;
end

if nargin < 3,
    window = width * 5 + 1;
end


if size(vector,1) > size(vector,2)
    isColumn = true;
else
    isColumn = false;
    vector = vector';
end

% Construct blurring window.
windowWidthInt = int16(window);
halfWidth = double(windowWidthInt / 2);
gaussFilter = Gaussian(-(halfWidth-1):(halfWidth-1), 0, width/2 ) ;
gaussFilter = gaussFilter / sum(gaussFilter);
%disp(gaussFilter)

% Do the blur, enlarging the vector to blur from the start with a
% convenient value and cutting the vector back when the blurring is done
enlargedVector = [ones(window, 1)*vector(1,:);
    vector;
    ones(window, 1)*vector(end,:)];
%size(enlargedVector)

smoothedVector = zeros(size(enlargedVector,1)-1,size(enlargedVector,2));

for i=1:size(vector,2)
    smoothedVector(:,i) = convolution(enlargedVector(halfWidth:end-halfWidth,i)', gaussFilter) ;
end

smoothedVector = smoothedVector(window:end-window,:);

% Rotate back the vector, if it was a row vector
if (isColumn == false)
    smoothedVector = smoothedVector';
end

end