// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint size;
  uint nblocks;
  uint ninodes;
  uint nlog;
  uint logstart;
  uint BGsize;
  uint nmeta;
  uint nswap;
  uint nBG;
  uint nbmapBG;
  uint ninodeBG;
  uint metaBG;
};

#define NDIRECT 11
#define NINDIRECT (BSIZE / sizeof(uint))
#define N2INDIRECT (BSIZE / sizeof(uint)) * (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT + N2INDIRECT)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+2];   // Data block addresses ( 2 is for NIN and NDIN )
};


#define BNUM(b, sb)  ((b-sb.nmeta)/sb.BGsize)
// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
// #define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit or block b
// #define BBLOCK(b, sb) (b/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

#define BGROUP(b, sb) (((b) - sb.nmeta) / sb.BGsize)
#define IBLOCKGROUP(i, sb) ((i) / sb.ninodeBG)
#define IBLOCKGROUPSTART(i, sb) (sb.nmeta + (IBLOCKGROUP((i),sb) * sb.BGsize))
#define BBLOCKGROUPSTART(b, sb) (sb.nmeta + ((b) * sb.BGsize))
#define IBLOCK(i,sb) (IBLOCKGROUPSTART((i),sb)+((i)%sb.ninodeBG))
#define BBLOCK(b, sb) (BGROUP(b,sb)*sb.BGsize + sb.ninodeBG +sb.nmeta+((b-sb.nmeta)%sb.BGsize)/BPB)

// BLOCK GROUP

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

