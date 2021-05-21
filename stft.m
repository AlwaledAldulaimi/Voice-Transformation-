
function S_stft = stft(s_modified, win_ham, hop_size, num_fft)


% column-vector siganl
s_modified = s_modified(:);

% Finding the length of the signal
s_modified_len = length(s_modified);

% fft window length
w_len = length(win_ham);

% stft matrix size estimation and preallocation
Unique_points = ceil((1+num_fft)/2);     % unique fft points
Fra_Num = 1+fix((s_modified_len-w_len)/hop_size); % signal frames Number
S_stft = zeros(Unique_points, Fra_Num);       % save space for the output signals

% STFT (via time-localized FFT)
for i = 0:Fra_Num-1
    % Do windoing
    s_modified_win(:,i+1) = s_modified(1+i*hop_size : w_len+i*hop_size).*win_ham;
    % Doing fft
    s_modified_win_fft = fft(s_modified_win(:,i+1), num_fft);
    % update the stft matrix
    S_stft(:, 1+i) = s_modified_win_fft(1:Unique_points);
end


end