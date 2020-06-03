if(isempty(gcp('nocreate')))
    parpool;
end
addpath '/tracker_benchmark_v1.0/trackers/TCF/matconvnet/matlab';
vl_setupnn;
gpuDevice(1);
addpath '/tracker_benchmark_v1.0/trackers/TCF/TCNN';
addpath '/tracker_benchmark_v1.0/trackers/TCF/TCNN/utils';
