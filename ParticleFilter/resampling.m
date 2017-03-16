function pnew = resampling(p, map)
% a simple resampling to do the job!

pnew = p;

p.w = p.w ./ sum(p.w);
for i=1:p.n
    idx = find(rand <= cumsum(p.w),1);
    pnew.x(i) = p.x(idx);
    pnew.y(i) = p.y(idx);
end

end