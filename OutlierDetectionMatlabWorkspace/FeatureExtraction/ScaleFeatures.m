function scaledDataMatrix = ScaleFeatures( data )
minimums = min(data , [], 1);
ranges = max(data, [], 1) - minimums;
scaledDataMatrix = (data - repmat(minimums, size(data, 1), 1)) ./ repmat(ranges, size(data, 1), 1);
end

