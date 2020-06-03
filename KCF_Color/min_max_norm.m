function B = min_max_norm(A,n_min,n_max)

[M,N]=size(A);

max_val=max(max(A));
min_val=min(min(A));

if max_val==min_val
    B=zeros(M,N);
    B=B+0.5;
else
    B=A;
    B=B-min_val;
    B=B/(max_val-min_val);
end

B=B*(n_max-n_min);
B=B+n_min;