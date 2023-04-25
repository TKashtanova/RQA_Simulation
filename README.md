# Quality Assurance of Radiotherapy using Scattered X-ray

> * Class: Computer Intergrated Surgery II
> * School: Johns Hopkins University
> * Term: Spring 2023
> * Students: Tatiana Kashtanova, Samuel Ydenberg
> * Mentors: Dr. Xun Jia, Dr. Lin Su (JHH)
> * Technical Support: Dr. Yujie Chi (UT Arlington); Dr. Youfang Lai, Dr. Xiaoyu Hu (JHH)

***Abstract***

The project objective is to implement a quality assurance method for radiation therapy using scattered x-ray registration allowing to verify dose distribution in a medium externally and in real time. First, using the gDPM Monte Carlo simulation package [1,2] developed by Dr. Jia and his team, we obtain the coordinates, momentum direction and energy of the photons scattered in a phantom after a MV x-ray beam has passed through it. Then, using MATLAB, we register the scattered photons on the sensor area of a photon counting detector with and without a 3D collimator positioned in front of it. Finally, we relate the recorded detector signal to the delivered radiation dose and analyze the quality assurance method feasibility. The procedures are carried out on both homogeneous and heterogeneous phantoms.


## References

[1] Jia, X. & Jiang, S.B. (2011). gDPM v2.0. A GPU-based Monte Carlo simulation package for radiotherapy dose calculation. The Center for Advanced Radiotherapy Technologies (CART), UCSD.

[2] Jia, X., Ziegenhein, P., & Jiang, S. B. (2014). GPU-based high-performance computing for radiation therapy. Physics in Medicine and Biology, 59(4), p. R151–R182.
