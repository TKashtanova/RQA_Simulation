# Quality Assurance of Radiotherapy using Scattered X-ray

> * Class: Computer Intergrated Surgery II
> * School: Johns Hopkins University
> * Term: Spring 2023
> * Students: Tatiana Kashtanova, Samuel Ydenberg
> * Mentors: Dr. Xun Jia, Dr. Lin Su (JHH)
> * Technical Support: Dr. Yujie Chi (UT Arlington); Dr. Youfang Lai, Dr. Xiaoyu Hu (JHH)

***Project Summary***

In this project, we implemented a quality assurance method for radiation therapy allowing to verify dose deposition in a medium externally and with no extra dose, using scattered x-ray registration. First, using the gDPM simulation package, we obtained the coordinates, momentum direction and energy of the photons scattered outside of a phantom after a MV x-ray beam passed through it. Then, using MATLAB, we collimated the scattered photons and registered them on a photon counting detector sensor. Finally, we related the recorded detector signal to the delivered radiation dose and analyzed the method feasibility. The procedures were carried out on both homogeneous and heterogeneous phantoms.


***References***

[1] Jia, X. & Jiang, S.B. (2011). gDPM v2.0. A GPU-based Monte Carlo simulation package for radiotherapy dose calculation. The Center for Advanced Radiotherapy Technologies (CART), UCSD.

[2] Jia, X., Ziegenhein, P., & Jiang, S. B. (2014). GPU-based high-performance computing for radiation therapy. Physics in Medicine and Biology, 59(4), p. R151–R182.
