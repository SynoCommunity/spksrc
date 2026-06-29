import pytest
import subprocess
import shlex

# Payloads and whether they are expected to inject when unquoted.
# The {sentinel} placeholder is replaced at test time with a unique tmp_path.
PAYLOADS = [
    pytest.param("iPhone; touch {sentinel}", True,  id="semicolon_injection"),
    pytest.param("iPhone`touch {sentinel}`", True,  id="backtick_injection"),
    pytest.param("My-iPhone-12",             False, id="clean_name"),
]


@pytest.mark.parametrize("payload_template,expect_injection", PAYLOADS)
def test_unquoted_command_is_injectable(payload_template, expect_injection, tmp_path):
    """Negative control: confirm the unquoted shell pattern IS vulnerable."""
    sentinel = tmp_path / "pwned"
    payload = payload_template.format(sentinel=str(sentinel))
    subprocess.run(
        "mount | grep %s" % payload,
        shell=True, capture_output=True, text=True,
    )
    if expect_injection:
        assert sentinel.exists(), (
            "Expected injection to create sentinel but it did not for payload %r" % payload
        )
    else:
        assert not sentinel.exists()


@pytest.mark.parametrize("payload_template,expect_injection", PAYLOADS)
def test_shlex_quote_prevents_injection(payload_template, expect_injection, tmp_path):
    """Confirm that shlex.quote neutralises all injection payloads."""
    sentinel = tmp_path / "pwned"
    payload = payload_template.format(sentinel=str(sentinel))
    subprocess.run(
        "mount | grep %s" % shlex.quote(payload),
        shell=True, capture_output=True, text=True,
    )
    assert not sentinel.exists(), (
        "shlex.quote did not prevent injection for payload %r" % payload
    )
