function [x] = istft(STFT, awin, swin, hop, nfft)

L = size(STFT, 2);          % determine the number of signal frames
wlen = length(swin);        % determine the length of the synthesis window
xlen = wlen + (L-1)*hop;    % estimate the length of the signal vector
x = zeros(1, xlen);         % preallocate the signal vector

% reconstruction of the whole spectrum
if rem(nfft, 2)             
    % odd nfft excludes 1st point
    X = [STFT; conj(flipud(STFT(2:end, :)))];
else                        
    % even nfft includes 1st point
    X = [STFT; conj(flipud(STFT(2:end-1, :)))];
end
% columnwise IFFT on the STFT-matrix

xw = real(ifft(X));
xw = xw(1:wlen, :);
% Weighted-OLA
for l = 1 : L
    xww(:,l) = xw(:, l).*swin;
end
% xww1 = xww';
xw1 = xww(:)';
% ii = 1;
for l = 1:L
%     1+(l-1)*hop
%     wlen+(l-1)*hop
    if (1+(l-1)*hop) > hop
%         1+(l-1)*hop
%         (wlen+(l-1)*hop)-hop
        Y = [];
        Y = xww(:,l);
        nxw = size(Y,1);
        x_cc_sum = [];
        for ik = 1 : nxw
            x_cc = [];
            x_cc = (x(1+(l-1)*hop : ((wlen+(l-1)*hop)-hop)) - Y(1:((((wlen+(l-1)*hop)-hop) - (1+(l-1)*hop))+1) , 1)').^2;
            x_cc_sum(ik) = sum(x_cc);
            Y=[];
            Y = circshift(xww(:,l),1);
        end
%         plot(x_cc_sum)
        [junk,I] = min(x_cc_sum);
%         I
%         ABA
        Y = [];
        Y = circshift(xww(:,l),I-1);
        x(1+(l-1)*hop : wlen+(l-1)*hop) = x(1+(l-1)*hop : wlen+(l-1)*hop) + ...
                                     (Y)'; 
        
%         ii = ii +1;
    else
        x(1+(l-1)*hop : wlen+(l-1)*hop) = x(1+(l-1)*hop : wlen+(l-1)*hop) + ...
                                     xw1(1+(l-1)*hop : wlen+(l-1)*hop); 
    end                              
       
                                  
end
% scaling of the signal
W0 = sum(awin.*swin); % awin swin  
x = x.*hop/W0;                      

end
