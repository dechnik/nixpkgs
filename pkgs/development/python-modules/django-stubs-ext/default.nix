{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "5.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "django_stubs_ext";
    inherit version;
    hash = "sha256-zTYfW5Ucar34Z8VdJHVB8GCdHoM0zLCcehKRARFCUjQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "django_stubs_ext" ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
