TOOLS:=tools.stamp

.PHONY: all
all: $(TOOLS)
	@true

$(TOOLS): packages.txt config/deps.py
	$(info doing [$@])
	@pymakehelper touch_mkdir $@

.PHONY: clean
clean:
	@git clean -qffxd
