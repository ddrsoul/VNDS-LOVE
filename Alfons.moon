switch_url = "https://github.com/lovebrew/lovepotion/releases/download/3.0.1/Nintendo.Switch-cb8f829.zip"
shfail = (command) -> --stop execution if a command failes
    _, _, code = sh command
    os.exit(code) unless code == 0
tasks:
	icons: =>
		sh "convert icons/icon.svg -resize 48x48 icons/icon.png"
		sh "convert icons/icon.svg -resize 256x256 icons/icon.jpg"
	clean: =>
		delete "vnds/" if fs.exists "vnds/"
	compile: =>
		tasks.clean!
		copy "src/", "vnds/"
		for file in wildcard "vnds/**.moon"
			sh "moonc #{file}"
			delete file
	run: =>
		tasks.compile!
		shfail "love vnds"
	test: => --runs off of src directly
		shfail "busted -C src ../spec"
	build: =>
		tasks.compile!
		shfail "love-release -W -M --uti 'ajusa.vnds' build vnds/"
	lovebrew: =>
		tasks.compile!
		print(tasks.fetch(switch_url))
