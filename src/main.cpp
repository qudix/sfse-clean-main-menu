SFSEPluginLoad(const SFSE::LoadInterface* a_sfse)
{
	SFSE::Init(a_sfse);

	logs::info("Hello World!");

	return true;
}
