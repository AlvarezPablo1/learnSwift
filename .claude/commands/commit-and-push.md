---
description: Stage all changes, commit, pull to sync, and push to the remote
---

Realizá el flujo completo de commit y push sobre el repo actual:

1. Ejecutá `git status` y `git diff` para ver qué cambió.
2. `git add -A` para preparar todos los cambios.
3. Creá un commit con un mensaje descriptivo basado en los cambios reales
   (si el usuario pasó un mensaje como argumento en `$ARGUMENTS`, usalo).
4. `git pull --rebase` para traer lo que haya en el remoto y evitar divergencias.
   - Si el pull genera conflictos, PARÁ, avisá al usuario y no sigas con el push.
5. Si el pull quedó limpio, `git push`.
6. Informá el resultado: hash del commit y confirmación del push.

Reglas:
- Si no hay cambios para commitear, avisá y no hagas nada más.
- No fuerces el push (`--force`) nunca.
