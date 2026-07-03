---
title: Model ↔ Architecture
description: Map a Synology platform (CPU codename) to its spksrc build architecture, family and example models — and back
---

# Model ↔ Architecture

spksrc identifies each Synology platform by its **CPU codename** (`apollolake`, `geminilake`, `rtd1296`, ...). Every codename belongs to an **architecture family** and is compiled with one of the generic **build architectures** (`x64`, `aarch64`, `armv7`, ...). The authoritative mapping lives in `mk/spksrc.common/archs.mk`; the families are summarised in [Reference: Architectures](architectures.md#architecture-groups).

To go **model → platform**, type your model in the search box (e.g. `DS920+`); the matching platform row is shown. To go **platform/family → models**, pick a family or type a codename.

For the authoritative CPU of a specific model, see Synology's [**What kind of CPU does my NAS have?**](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have).

<p>
  <label>Family:
    <select id="famFilter" onchange="filterModelTable()">
      <option value="">All</option>
      <option value="x64">x64 (Intel/AMD 64-bit)</option>
      <option value="armv8">ARMv8 (aarch64)</option>
      <option value="armv7">ARMv7 (armv7)</option>
      <option value="armv7l">ARMv7L</option>
      <option value="armv5">ARMv5</option>
      <option value="ppc">PowerPC</option>
      <option value="i686">i686</option>
    </select>
  </label>
  &nbsp;
  <input id="modelSearch" type="text" placeholder="Search a model (e.g. DS920+) or codename…" oninput="filterModelTable()" size="34">
</p>

<table id="modelTable" markdown="0">
  <thead>
    <tr><th>Platform</th><th>Family</th><th>Build arch</th><th>CPU</th><th>Integrated GPU</th><th>Example models</th></tr>
  </thead>
  <tbody>
    <tr data-family="x64"><td>geminilake</td><td>x64</td><td>x64</td><td>Intel</td><td>Intel UHD Graphics 605 (Gen9.5)</td><td>DS224+, DS423+, DVA1622, DS220+, DS420+, DS720+, DS920+, DS1520+</td></tr>
    <tr data-family="x64"><td>apollolake</td><td>x64</td><td>x64</td><td>Intel</td><td>Intel HD Graphics 500/505 (Gen9, Broxton)</td><td>DS620slim, DS1019+, DS218+, DS418play, DS718+, DS918+</td></tr>
    <tr data-family="x64"><td>braswell</td><td>x64</td><td>x64</td><td>Intel</td><td>Intel HD Graphics (Gen8)</td><td>DS916+, DS716+, DS216+</td></tr>
    <tr data-family="x64"><td>denverton</td><td>x64</td><td>x64</td><td>Intel Atom C3000</td><td>—</td><td>DVA3221, RS820+, DS2419+, DS1819+, DS1618+</td></tr>
    <tr data-family="x64"><td>avoton</td><td>x64</td><td>x64</td><td>Intel Atom C2000</td><td>—</td><td>DS1817+, DS1517+, DS1815+, DS415+, RS815+</td></tr>
    <tr data-family="x64"><td>broadwell</td><td>x64</td><td>x64</td><td>Intel Xeon-D</td><td>—</td><td>FS3400, RS3618xs, RS3617xs+, DS3617xs</td></tr>
    <tr data-family="x64"><td>bromolow</td><td>x64</td><td>x64</td><td>Intel Xeon</td><td>—</td><td>RS3614xs, DS3612xs, DS3615xs</td></tr>
    <tr data-family="x64"><td>v1000</td><td>x64</td><td>x64</td><td>AMD Ryzen V1500B</td><td>—</td><td>DS1621+, DS1821+, RS1221+, DS1823xs+, RS822+</td></tr>
    <tr data-family="x64"><td>r1000</td><td>x64</td><td>x64</td><td>AMD Ryzen R1600</td><td>—</td><td>DS923+, DS723+, DS1522+, RS422+</td></tr>
    <tr data-family="x64"><td>epyc7002 / purley / grantley</td><td>x64</td><td>x64</td><td>Intel Xeon / AMD EPYC</td><td>—</td><td>high-end FS/SA/RS models</td></tr>
    <tr data-family="armv8"><td>rtd1296</td><td>ARMv8</td><td>aarch64</td><td>Realtek</td><td>ARM Mali-T820 (not used for transcoding)</td><td>DS420j, DS220j, RS819, DS418, DS218, DS118</td></tr>
    <tr data-family="armv8"><td>rtd1619b</td><td>ARMv8</td><td>aarch64</td><td>Realtek</td><td>ARM Mali (not used for transcoding)</td><td>DS223, DS223j, DS423, DS124</td></tr>
    <tr data-family="armv8"><td>armada37xx</td><td>ARMv8</td><td>aarch64</td><td>Marvell</td><td>—</td><td>DS120j, DS119j</td></tr>
    <tr data-family="armv7"><td>armada38x</td><td>ARMv7</td><td>armv7</td><td>Marvell</td><td>—</td><td>DS218j, DS118, DS419slim, RS217</td></tr>
    <tr data-family="armv7"><td>alpine</td><td>ARMv7</td><td>armv7</td><td>Annapurna AL-314</td><td>—</td><td>DS416, DS1517, DS1817, DS713+</td></tr>
    <tr data-family="armv7"><td>monaco</td><td>ARMv7</td><td>armv7</td><td>STM Monaco</td><td>—</td><td>DS215+</td></tr>
    <tr data-family="armv7"><td>comcerto2k</td><td>ARMv7</td><td>armv7</td><td>Mindspeed Comcerto</td><td>—</td><td>DS414j, RS214</td></tr>
    <tr data-family="armv7"><td>armada370 / armada375 / armadaxp</td><td>ARMv7</td><td>armv7</td><td>Marvell</td><td>—</td><td>DS115j, DS214, DS414</td></tr>
    <tr data-family="armv7l"><td>hi3535</td><td>ARMv7L</td><td>armv7l</td><td>HiSilicon</td><td>—</td><td>(surveillance / legacy models)</td></tr>
    <tr data-family="armv5"><td>88f6281</td><td>ARMv5</td><td>armv5</td><td>Marvell Kirkwood</td><td>—</td><td>DS112, DS212, DS411 (legacy)</td></tr>
    <tr data-family="ppc"><td>qoriq</td><td>PowerPC</td><td>qoriq</td><td>Freescale QorIQ</td><td>—</td><td>DS213+, DS413, RS812</td></tr>
    <tr data-family="ppc"><td>ppc853x / ppc854x / ppc824x</td><td>PowerPC</td><td>ppc</td><td>Freescale</td><td>—</td><td>DS109, DS209, DS409 (legacy)</td></tr>
    <tr data-family="i686"><td>evansport</td><td>i686</td><td>i686</td><td>Intel Atom CE5300</td><td>—</td><td>DS214play, DS415play</td></tr>
  </tbody>
</table>

<script>
function filterModelTable() {
  var f = document.getElementById('famFilter').value.toLowerCase();
  var q = document.getElementById('modelSearch').value.toLowerCase();
  document.querySelectorAll('#modelTable tbody tr').forEach(function (r) {
    var okFam = !f || r.getAttribute('data-family') === f;
    var okText = !q || r.textContent.toLowerCase().indexOf(q) >= 0;
    r.style.display = (okFam && okText) ? '' : 'none';
  });
}
</script>

!!! note "Model examples"
    Model lists are representative, not exhaustive — Synology reuses a platform across many models and revisions. Use the search box for your exact model, and confirm the CPU on the [Synology page](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have). The full platform-to-family mapping is in `mk/spksrc.common/archs.mk`.

Hardware transcoding through the [SynoCli Video Driver](../packages/synocli-videodriver.md) targets **Intel iGPUs** (`apollolake`, `geminilake`, `braswell`). The Synology AMD (`v1000`/`r1000`) SKUs ship **without** an integrated GPU, and the ARM Mali GPUs are not driven by the Intel VA-API/QSV stack.

## See also

- [Reference: Architectures](architectures.md) — families, groups and build arches
