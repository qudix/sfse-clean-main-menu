#include "config.h"

void OnPostLoad()
{
	const auto config = Config::GetSingleton();
	const auto ini = RE::INISettingCollection::GetSingleton();

	if (!config->Value("MainMenu.UI.Delay", false))
		ini->SetSetting("uMainMenuDelayBeforeAllowSkip:General", 0u);

	if (!config->Value("MainMenu.UI.Intro", false)) {
		ini->SetSetting("bPreloadIntroSequence:General", false);
		ini->SetSetting("sIntroSequence:General", "");
	}

	if (!config->Value("MainMenu.UI.Motd", false))
		ini->SetSetting("bEnableMessageOfTheDay:General", false);
}

void OnMessage(SFSE::MessagingInterface::Message* a_msg) noexcept
{
	switch (a_msg->type) {
		case SFSE::MessagingInterface::kPostLoad: OnPostLoad(); break;
	}
}

void OnMenu(RE::IMenu* a_menu)
{
	if (!a_menu || a_menu->menuName != "MainMenu")
		return;

	const auto config = Config::GetSingleton();
	if (!config->Value("MainMenu.UI.BethLogo", false)) {
		RE::Scaleform::GFx::Value obj;
		if (a_menu->menuObj.GetMember("BethesdaLogo_mc", &obj))
			obj.SetMember("y", -500);
	}

	if (!config->Value("MainMenu.UI.GameLogo", false)) {
		RE::Scaleform::GFx::Value obj;
		if (a_menu->menuObj.GetMember("GameLogo_mc", &obj))
			obj.SetMember("y", -500);
	}
}

SFSEPluginLoad(const SFSE::LoadInterface* a_sfse)
{
	SFSE::Init(a_sfse);

	const auto plugin = SFSE::PluginVersionData::GetSingleton();
	logs::info("{} v{}", plugin->GetPluginName(), plugin->GetPluginVersion());

	if (const auto config = Config::GetSingleton()) {
		config->Load();
		if (!config->Value("MainMenu.Enable", true))
			return true;
	}

	if (const auto message = SFSE::GetMessagingInterface())
		message->RegisterListener(OnMessage);

	if (const auto menu = SFSE::GetMenuInterface())
		menu->Register(OnMenu);

	return true;
}
