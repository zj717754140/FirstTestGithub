% This script can be used to test the integration of a tracker to the
% framework.

addpath('/home/mooyeol/Documents/MATLAB/VOTnew16/vot-toolkit'); toolkit_path; % Make sure that VOT toolkit is in the path

[sequences, experiments] = workspace_load();

tracker = tracker_load('TCNN0614original');

workspace_test(tracker, sequences);

