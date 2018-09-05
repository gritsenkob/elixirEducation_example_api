ExUnit.start()

ExUnit.configure exclude: Application.get_env(:api, :tests_to_exclude)
