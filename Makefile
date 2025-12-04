venvdir := virtualenv
requdir := .

all: venv

venv: ${requdir}/${venvdir}/bin/activate

${requdir}/${venvdir}/bin/activate: ${requdir}/requirements.txt
	test -d ${requdir}/${venvdir} || python3 -m venv ${requdir}/${venvdir}
	${requdir}/${venvdir}/bin/pip install --upgrade pip
	${requdir}/${venvdir}/bin/pip install -Ur ${requdir}/requirements.txt
	touch ${requdir}/${venvdir}/bin/activate
	@echo ""
	@echo "=========================================="
	@echo "Virtual environment created successfully!"
	@echo "To activate, run: source ${requdir}/${venvdir}/bin/activate"
	@echo "=========================================="

clean:
	rm -rf ${requdir}/virtualenv
	rm -rf __pycache__
	find -iname "*.pyc" -delete


clean-vivado:
	python3 clean_vivado.py

clean-all: clean clean-vivado
	rm -rf citrap citrap_tmp

.PHONY: all venv clean clean-vivado clean-all

