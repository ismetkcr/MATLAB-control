function sz = find_size(m)

  sz = [0 0];

  isError = false;
  while ~isError
    try
      b = m(sz(1) + 1, :);
      sz(1) = sz(1) + 1;
    catch
      isError = true;
    end
  end

  isError = false;
  while ~isError
    try
      b = m(:, sz(2) + 1);
      sz(2) = sz(2) + 1;
    catch
      isError = true;
    end
  end

end