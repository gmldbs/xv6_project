struct mmap_area{
    struct file* f;
    uint addr;
    int length;
    int offset;
    int prot;
    int flags;
    struct proc *p;
};
