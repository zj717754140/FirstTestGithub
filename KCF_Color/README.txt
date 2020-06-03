This code library is for research purpose only.

The code is based on the original implementation of KCF [1], and is used to evaluate different color models. Please refer to [2] for details. 

Execute "run_color_benchmark.m" to run KCF [1] with different color models.

The correspondence between the name of color model in the code and in [2]:

COPPONENT -> C-OPP
GRAY -> Intensity
HSV -> HSV
HUE -> Hue
LAB -> LAB
NOPPONENT -> N-OPP
NRGB -> rg
OPPONENT -> OPP
RGB -> RGB
TRGB -> TRGB

If you have any questions, please contact Pengpeng Liang at pliang AT temple.edu or Haibin Ling at hbling AT temple.edu.

__________
References

[1] J. F. Henriques, R. Caseiro, P. Martins, J. Batista, "High-Speed Tracking with
Kernelized Correlation Filters", TPAMI 2014

[2] P. Liang, E. Blasch, and H. Ling, "Encoding Color Information for Visual Tracking: Algorithms and Benchmark", IEEE Trans. Image Processing 24(12):5630-5644,2015


______________________________________________________________
Following is the original "readme" of [1].


             High-Speed Tracking with Kernelized Correlation Filters

             J. F. Henriques   R. Caseiro   P. Martins   J. Batista
                                   TPAMI 2014

________________
To be published.
arXiv pre-print: http://arxiv.org/abs/1404.7584
Project webpage: http://www.isr.uc.pt/~henriques/circulant/

This MATLAB code implements a simple tracking pipeline based on the Kernelized
Correlation Filter (KCF), and Dual Correlation Filter (DCF).

It is free for research use. If you find it useful, please acknowledge the paper
above with a reference.


__________
Quickstart

1. Extract code somewhere.

2. The tracker is prepared to run on any of the 50 videos of the Visual Tracking
   Benchmark [3]. For that, it must know where they are/will be located. You can
   change the default location 'base_path' in 'download_videos.m' and 'run_tracker.m'.

3. If you don't have the videos already, run 'download_videos.m' (may take some time).

4. Execute 'run_tracker' without parameters to choose a video and test the KCF on it.


Note: The tracker uses the 'fhog'/'gradientMex' functions from Piotr's Toolbox.
Some pre-compiled MEX files are provided for convenience. If they do not work for your
system, just get the toolbox from http://vision.ucsd.edu/~pdollar/toolbox/doc/index.html


__________

The main interface function is 'run_tracker'. You can test several configurations (KCF,
DCF, MOSSE) by calling it with different commands:


 run_tracker
   Without any parameters, will ask you to choose a video, track using
   the Gaussian KCF on HOG, and show the results in an interactive
   figure. Press 'Esc' to stop the tracker early. You can navigate the
   video using the scrollbar at the bottom.

 run_tracker VIDEO
   Allows you to select a VIDEO by its name. 'all' will run all videos
   and show average statistics. 'choose' will select one interactively.

 run_tracker VIDEO KERNEL
   Choose a KERNEL. 'gaussian'/'polynomial' to run KCF, 'linear' for DCF.

 run_tracker VIDEO KERNEL FEATURE
   Choose a FEATURE type, either 'hog' or 'gray' (raw pixels).

 run_tracker(VIDEO, KERNEL, FEATURE, SHOW_VISUALIZATION, SHOW_PLOTS)
   Decide whether to show the scrollable figure, and the precision plot.

 Useful combinations:
 >> run_tracker choose gaussian hog  %Kernelized Correlation Filter (KCF)
 >> run_tracker choose linear hog    %Dual Correlation Filter (DCF)
 >> run_tracker choose gaussian gray %Single-channel KCF (ECCV'12 paper)
 >> run_tracker choose linear gray   %MOSSE filter (single channel)


For the actual tracking code, check out the 'tracker' function.


Though it's not required, the code will make use of the MATLAB Parallel Computing
Toolbox automatically if available.


__________
References

[1] J. F. Henriques, R. Caseiro, P. Martins, J. Batista, "High-Speed Tracking with
Kernelized Correlation Filters", TPAMI 2014 (to be published).

[2] J. F. Henriques, R. Caseiro, P. Martins, J. Batista, "Exploiting the Circulant
Structure of Tracking-by-detection with Kernels", ECCV 2012.

[3] Y. Wu, J. Lim, M.-H. Yang, "Online Object Tracking: A Benchmark", CVPR 2013.
Website: http://visual-tracking.net/

[4] P. Dollar, "Piotr's Image and Video Matlab Toolbox (PMT)".
Website: http://vision.ucsd.edu/~pdollar/toolbox/doc/index.html

[5] P. Dollar, S. Belongie, P. Perona, "The Fastest Pedestrian Detector in the
West", BMVC 2010.


_____________________________________
Copyright (c) 2014, Joao F. Henriques

Permission to use, copy, modify, and distribute this software for research
purposes with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


 