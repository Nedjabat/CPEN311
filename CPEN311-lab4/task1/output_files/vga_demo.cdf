/* Quartus Prime Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(5CSEMA5F31) MfrSpec(OpMask(0) FullPath("C:/School/CPEN 311/CPEN311-lab4/task1/output_files/vga_demo.sof"));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("C:/School/CPEN 311/CPEN311-lab4/task1/output_files/") File("vga_demo.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
