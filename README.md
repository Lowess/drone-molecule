drone-molecule
====================

* Author: `Florian Dambrine - @Lowess`

Drone plugin for Molecule (Ansible testing framework)

**Tips:**

* You can use environment variables in `molecule.yml` and pass them from Drone using `environment`.
* You can use Ansible `lookups` to read environment variables defined in Drone `environment` section.

# :notebook: Usage

* Execute `molecule test` on the ansible role. It uses a named volume to store molecule internal content so that you can run Molecule in multiple stages in the pipeline.

```yaml
---

pipeline:

    molecule:
      image: lowess/drone-molecule:2.6.8
      pull: true
      task: test
      environment:
        - CI_UUID=_molecule_${DRONE_COMMIT_SHA}
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - molecule_${DRONE_COMMIT_SHA}:/tmp
```

---

# :gear: Parameter Reference

* `task`

A valid [Molecule](https://molecule.readthedocs.io/en/latest/) command  (Example: `lint`,`create`, `converge`, `idempotence`, `test`, ...)

---

# :beginner: Development

* Run the plugin directly from a built Docker image:

```bash
docker run -i \
           -w /opt/molecule \
           -v $(pwd):/opt/molecule \
           -e PLUGIN_TASK=test \
           -e PLUGIN_ESG_NAME=va-dsci--verity \
           lowess/drone-molecule:2.6.8
```
