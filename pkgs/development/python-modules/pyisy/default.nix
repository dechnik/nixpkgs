{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, python-dateutil
, aiohttp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyisy";
  version = "3.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "automicus";
    repo = "PyISY";
    rev = "refs/tags/v${version}";
    hash = "sha256-nThHJYU23I9q5Irk5SoW1+dy5Agl9IJc5gnLirzp3YM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools-git-version" "" \
      --replace 'version_format="{tag}"' 'version="${version}"'
  '';

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyisy" ];

  meta = with lib; {
    description = "Python module to talk to ISY994 from UDI";
    homepage = "https://github.com/automicus/PyISY";
    changelog = "https://github.com/automicus/PyISY/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
