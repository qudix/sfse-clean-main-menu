#pragma once

class Config final
{
public:
	static Config* GetSingleton()
	{
		static Config config;
		return std::addressof(config);
	}

	void Load()
	{
		auto plugin = SFSE::PluginVersionData::GetSingleton();
		auto path = std::format("data/sfse/plugins/{}.toml", plugin->GetPluginName());
		auto pathCustom = std::format("data/sfse/plugins/{}_custom.toml", plugin->GetPluginName());

		_result = toml::parse_file(path);
		if (!_result)
			logs::error("failed to load default config: {}", _result.error().description());

		_resultCustom = toml::parse_file(pathCustom);
		if (!_resultCustom && std::filesystem::exists(pathCustom))
			logs::error("failed to load custom config: {}", _resultCustom.error().description());
	}

	auto Value(const std::string_view a_path, const bool a_default)
	{
		const auto node = impl(a_path);
		if (node && node.is_boolean())
			return node.value_or(a_default);

		return a_default;
	}

	auto Value(const std::string_view a_path, const std::int32_t a_default)
	{
		const auto node = impl(a_path);
		if (node && node.is_integer())
			return node.value_or(a_default);

		return a_default;
	}

	auto Value(const std::string_view a_path, const std::uint32_t a_default)
	{
		const auto node = impl(a_path);
		if (node && node.is_integer())
			return node.value_or(a_default);

		return a_default;
	}

	auto Value(const std::string_view a_path, const float a_default)
	{
		const auto node = impl(a_path);
		if (node && node.is_floating_point())
			return node.value_or(a_default);

		return a_default;
	}

	auto Value(const std::string_view a_path, const std::string_view a_default)
	{
		const auto node = impl(a_path);
		if (node && node.is_string())
			return node.value_or(a_default);

		return a_default;
	}

private:
	Config() = default;
	Config(Config&&) = delete;
	Config(const Config&) = delete;
	~Config() = default;

	auto impl(const std::string_view a_path)
		-> toml::node_view<toml::node>
	{
		if (_resultCustom) {
			auto& table = _resultCustom.table();
			if (const auto node = table.at_path(a_path))
				return node;
		}

		if (_result) {
			auto& table = _result.table();
			if (const auto node = table.at_path(a_path))
				return node;
		}

		return {};
	}

private:
	toml::parse_result _result;
	toml::parse_result _resultCustom;
};
