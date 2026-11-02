Tests:
Check permutations of the following panels and their positions:

- Taskbar (`top`/`bottom`/`left`/`right`)
- Dashboard (`left`/`right`/`top`)
- Utilities (`top right`/`bottom right`/`top left`/`bottom left`)
- Sidebar (`left`/`right`)
- OSD (`left`/`right`)

Incompatibilities:

- Taskbar `top` & Utilities `top left`
- Taskbar `bottom` & Utilities `bottom left`
- Taskbar `left` & Utilities `top left`
- Taskbar `right` & Utilities `top right`

Complete list:

| Taskbar  | Dashboard | Utilities      | Sidebar | OSD     | Ok ?         |
| -------- | --------- | -------------- | ------- | ------- | ------------ |
| `top`    | `left`    | `top right`    | `left`  | `left`  |              |
| `top`    | `left`    | `top right`    | `left`  | `right` |              |
| `top`    | `left`    | `top right`    | `right` | `left`  |              |
| `top`    | `left`    | `top right`    | `right` | `right` |              |
| `top`    | `left`    | `bottom right` | `left`  | `left`  |              |
| `top`    | `left`    | `bottom right` | `left`  | `right` |              |
| `top`    | `left`    | `bottom right` | `right` | `left`  |              |
| `top`    | `left`    | `bottom right` | `right` | `right` |              |
| `top`    | `left`    | `top left`     | `left`  | `left`  | Incompatible |
| `top`    | `left`    | `top left`     | `left`  | `right` | Incompatible |
| `top`    | `left`    | `top left`     | `right` | `left`  | Incompatible |
| `top`    | `left`    | `top left`     | `right` | `right` | Incompatible |
| `top`    | `left`    | `bottom left`  | `left`  | `left`  |              |
| `top`    | `left`    | `bottom left`  | `left`  | `right` |              |
| `top`    | `left`    | `bottom left`  | `right` | `left`  |              |
| `top`    | `left`    | `bottom left`  | `right` | `right` |              |
| `top`    | `right`   | `top right`    | `left`  | `left`  |              |
| `top`    | `right`   | `top right`    | `left`  | `right` |              |
| `top`    | `right`   | `top right`    | `right` | `left`  |              |
| `top`    | `right`   | `top right`    | `right` | `right` |              |
| `top`    | `right`   | `bottom right` | `left`  | `left`  |              |
| `top`    | `right`   | `bottom right` | `left`  | `right` |              |
| `top`    | `right`   | `bottom right` | `right` | `left`  |              |
| `top`    | `right`   | `bottom right` | `right` | `right` |              |
| `top`    | `right`   | `top left`     | `left`  | `left`  | Incompatible |
| `top`    | `right`   | `top left`     | `left`  | `right` | Incompatible |
| `top`    | `right`   | `top left`     | `right` | `left`  | Incompatible |
| `top`    | `right`   | `top left`     | `right` | `right` | Incompatible |
| `top`    | `right`   | `bottom left`  | `left`  | `left`  |              |
| `top`    | `right`   | `bottom left`  | `left`  | `right` |              |
| `top`    | `right`   | `bottom left`  | `right` | `left`  |              |
| `top`    | `right`   | `bottom left`  | `right` | `right` |              |
| `top`    | `top`     | `top right`    | `left`  | `left`  |              |
| `top`    | `top`     | `top right`    | `left`  | `right` |              |
| `top`    | `top`     | `top right`    | `right` | `left`  |              |
| `top`    | `top`     | `top right`    | `right` | `right` |              |
| `top`    | `top`     | `bottom right` | `left`  | `left`  |              |
| `top`    | `top`     | `bottom right` | `left`  | `right` |              |
| `top`    | `top`     | `bottom right` | `right` | `left`  |              |
| `top`    | `top`     | `bottom right` | `right` | `right` |              |
| `top`    | `top`     | `top left`     | `left`  | `left`  | Incompatible |
| `top`    | `top`     | `top left`     | `left`  | `right` | Incompatible |
| `top`    | `top`     | `top left`     | `right` | `left`  | Incompatible |
| `top`    | `top`     | `top left`     | `right` | `right` | Incompatible |
| `top`    | `top`     | `bottom left`  | `left`  | `left`  |              |
| `top`    | `top`     | `bottom left`  | `left`  | `right` |              |
| `top`    | `top`     | `bottom left`  | `right` | `left`  |              |
| `top`    | `top`     | `bottom left`  | `right` | `right` |              |
| `bottom` | `left`    | `top right`    | `left`  | `left`  |              |
| `bottom` | `left`    | `top right`    | `left`  | `right` |              |
| `bottom` | `left`    | `top right`    | `right` | `left`  |              |
| `bottom` | `left`    | `top right`    | `right` | `right` |              |
| `bottom` | `left`    | `bottom right` | `left`  | `left`  |              |
| `bottom` | `left`    | `bottom right` | `left`  | `right` |              |
| `bottom` | `left`    | `bottom right` | `right` | `left`  |              |
| `bottom` | `left`    | `bottom right` | `right` | `right` |              |
| `bottom` | `left`    | `top left`     | `left`  | `left`  |              |
| `bottom` | `left`    | `top left`     | `left`  | `right` |              |
| `bottom` | `left`    | `top left`     | `right` | `left`  |              |
| `bottom` | `left`    | `top left`     | `right` | `right` |              |
| `bottom` | `left`    | `bottom left`  | `left`  | `left`  | Incompatible |
| `bottom` | `left`    | `bottom left`  | `left`  | `right` | Incompatible |
| `bottom` | `left`    | `bottom left`  | `right` | `left`  | Incompatible |
| `bottom` | `left`    | `bottom left`  | `right` | `right` | Incompatible |
| `bottom` | `right`   | `top right`    | `left`  | `left`  |              |
| `bottom` | `right`   | `top right`    | `left`  | `right` |              |
| `bottom` | `right`   | `top right`    | `right` | `left`  |              |
| `bottom` | `right`   | `top right`    | `right` | `right` |              |
| `bottom` | `right`   | `bottom right` | `left`  | `left`  |              |
| `bottom` | `right`   | `bottom right` | `left`  | `right` |              |
| `bottom` | `right`   | `bottom right` | `right` | `left`  |              |
| `bottom` | `right`   | `bottom right` | `right` | `right` |              |
| `bottom` | `right`   | `top left`     | `left`  | `left`  |              |
| `bottom` | `right`   | `top left`     | `left`  | `right` |              |
| `bottom` | `right`   | `top left`     | `right` | `left`  |              |
| `bottom` | `right`   | `top left`     | `right` | `right` |              |
| `bottom` | `right`   | `bottom left`  | `left`  | `left`  | Incompatible |
| `bottom` | `right`   | `bottom left`  | `left`  | `right` | Incompatible |
| `bottom` | `right`   | `bottom left`  | `right` | `left`  | Incompatible |
| `bottom` | `right`   | `bottom left`  | `right` | `right` | Incompatible |
| `bottom` | `top`     | `top right`    | `left`  | `left`  |              |
| `bottom` | `top`     | `top right`    | `left`  | `right` |              |
| `bottom` | `top`     | `top right`    | `right` | `left`  |              |
| `bottom` | `top`     | `top right`    | `right` | `right` |              |
| `bottom` | `top`     | `bottom right` | `left`  | `left`  |              |
| `bottom` | `top`     | `bottom right` | `left`  | `right` |              |
| `bottom` | `top`     | `bottom right` | `right` | `left`  |              |
| `bottom` | `top`     | `bottom right` | `right` | `right` |              |
| `bottom` | `top`     | `top left`     | `left`  | `left`  |              |
| `bottom` | `top`     | `top left`     | `left`  | `right` |              |
| `bottom` | `top`     | `top left`     | `right` | `left`  |              |
| `bottom` | `top`     | `top left`     | `right` | `right` |              |
| `bottom` | `top`     | `bottom left`  | `left`  | `left`  | Incompatible |
| `bottom` | `top`     | `bottom left`  | `left`  | `right` | Incompatible |
| `bottom` | `top`     | `bottom left`  | `right` | `left`  | Incompatible |
| `bottom` | `top`     | `bottom left`  | `right` | `right` | Incompatible |
| `left`   | `left`    | `top right`    | `left`  | `left`  |              |
| `left`   | `left`    | `top right`    | `left`  | `right` |              |
| `left`   | `left`    | `top right`    | `right` | `left`  |              |
| `left`   | `left`    | `top right`    | `right` | `right` |              |
| `left`   | `left`    | `bottom right` | `left`  | `left`  |              |
| `left`   | `left`    | `bottom right` | `left`  | `right` |              |
| `left`   | `left`    | `bottom right` | `right` | `left`  |              |
| `left`   | `left`    | `bottom right` | `right` | `right` |              |
| `left`   | `left`    | `top left`     | `left`  | `left`  | Incompatible |
| `left`   | `left`    | `top left`     | `left`  | `right` | Incompatible |
| `left`   | `left`    | `top left`     | `right` | `left`  | Incompatible |
| `left`   | `left`    | `top left`     | `right` | `right` | Incompatible |
| `left`   | `left`    | `bottom left`  | `left`  | `left`  |              |
| `left`   | `left`    | `bottom left`  | `left`  | `right` |              |
| `left`   | `left`    | `bottom left`  | `right` | `left`  |              |
| `left`   | `left`    | `bottom left`  | `right` | `right` |              |
| `left`   | `right`   | `top right`    | `left`  | `left`  |              |
| `left`   | `right`   | `top right`    | `left`  | `right` |              |
| `left`   | `right`   | `top right`    | `right` | `left`  |              |
| `left`   | `right`   | `top right`    | `right` | `right` |              |
| `left`   | `right`   | `bottom right` | `left`  | `left`  |              |
| `left`   | `right`   | `bottom right` | `left`  | `right` |              |
| `left`   | `right`   | `bottom right` | `right` | `left`  |              |
| `left`   | `right`   | `bottom right` | `right` | `right` |              |
| `left`   | `right`   | `top left`     | `left`  | `left`  | Incompatible |
| `left`   | `right`   | `top left`     | `left`  | `right` | Incompatible |
| `left`   | `right`   | `top left`     | `right` | `left`  | Incompatible |
| `left`   | `right`   | `top left`     | `right` | `right` | Incompatible |
| `left`   | `right`   | `bottom left`  | `left`  | `left`  |              |
| `left`   | `right`   | `bottom left`  | `left`  | `right` |              |
| `left`   | `right`   | `bottom left`  | `right` | `left`  |              |
| `left`   | `right`   | `bottom left`  | `right` | `right` |              |
| `left`   | `top`     | `top right`    | `left`  | `left`  |              |
| `left`   | `top`     | `top right`    | `left`  | `right` |              |
| `left`   | `top`     | `top right`    | `right` | `left`  |              |
| `left`   | `top`     | `top right`    | `right` | `right` |              |
| `left`   | `top`     | `bottom right` | `left`  | `left`  |              |
| `left`   | `top`     | `bottom right` | `left`  | `right` |              |
| `left`   | `top`     | `bottom right` | `right` | `left`  |              |
| `left`   | `top`     | `bottom right` | `right` | `right` |              |
| `left`   | `top`     | `top left`     | `left`  | `left`  | Incompatible |
| `left`   | `top`     | `top left`     | `left`  | `right` | Incompatible |
| `left`   | `top`     | `top left`     | `right` | `left`  | Incompatible |
| `left`   | `top`     | `top left`     | `right` | `right` | Incompatible |
| `left`   | `top`     | `bottom left`  | `left`  | `left`  |              |
| `left`   | `top`     | `bottom left`  | `left`  | `right` |              |
| `left`   | `top`     | `bottom left`  | `right` | `left`  |              |
| `left`   | `top`     | `bottom left`  | `right` | `right` |              |
| `right`  | `left`    | `top right`    | `left`  | `left`  | Incompatible |
| `right`  | `left`    | `top right`    | `left`  | `right` | Incompatible |
| `right`  | `left`    | `top right`    | `right` | `left`  | Incompatible |
| `right`  | `left`    | `top right`    | `right` | `right` | Incompatible |
| `right`  | `left`    | `bottom right` | `left`  | `left`  |              |
| `right`  | `left`    | `bottom right` | `left`  | `right` |              |
| `right`  | `left`    | `bottom right` | `right` | `left`  |              |
| `right`  | `left`    | `bottom right` | `right` | `right` |              |
| `right`  | `left`    | `top left`     | `left`  | `left`  |              |
| `right`  | `left`    | `top left`     | `left`  | `right` |              |
| `right`  | `left`    | `top left`     | `right` | `left`  |              |
| `right`  | `left`    | `top left`     | `right` | `right` |              |
| `right`  | `left`    | `bottom left`  | `left`  | `left`  |              |
| `right`  | `left`    | `bottom left`  | `left`  | `right` |              |
| `right`  | `left`    | `bottom left`  | `right` | `left`  |              |
| `right`  | `left`    | `bottom left`  | `right` | `right` |              |
| `right`  | `right`   | `top right`    | `left`  | `left`  | Incompatible |
| `right`  | `right`   | `top right`    | `left`  | `right` | Incompatible |
| `right`  | `right`   | `top right`    | `right` | `left`  | Incompatible |
| `right`  | `right`   | `top right`    | `right` | `right` | Incompatible |
| `right`  | `right`   | `bottom right` | `left`  | `left`  |              |
| `right`  | `right`   | `bottom right` | `left`  | `right` |              |
| `right`  | `right`   | `bottom right` | `right` | `left`  |              |
| `right`  | `right`   | `bottom right` | `right` | `right` |              |
| `right`  | `right`   | `top left`     | `left`  | `left`  |              |
| `right`  | `right`   | `top left`     | `left`  | `right` |              |
| `right`  | `right`   | `top left`     | `right` | `left`  |              |
| `right`  | `right`   | `top left`     | `right` | `right` |              |
| `right`  | `right`   | `bottom left`  | `left`  | `left`  |              |
| `right`  | `right`   | `bottom left`  | `left`  | `right` |              |
| `right`  | `right`   | `bottom left`  | `right` | `left`  |              |
| `right`  | `right`   | `bottom left`  | `right` | `right` |              |
| `right`  | `top`     | `top right`    | `left`  | `left`  | Incompatible |
| `right`  | `top`     | `top right`    | `left`  | `right` | Incompatible |
| `right`  | `top`     | `top right`    | `right` | `left`  | Incompatible |
| `right`  | `top`     | `top right`    | `right` | `right` | Incompatible |
| `right`  | `top`     | `bottom right` | `left`  | `left`  |              |
| `right`  | `top`     | `bottom right` | `left`  | `right` |              |
| `right`  | `top`     | `bottom right` | `right` | `left`  |              |
| `right`  | `top`     | `bottom right` | `right` | `right` |              |
| `right`  | `top`     | `top left`     | `left`  | `left`  |              |
| `right`  | `top`     | `top left`     | `left`  | `right` |              |
| `right`  | `top`     | `top left`     | `right` | `left`  |              |
| `right`  | `top`     | `top left`     | `right` | `right` |              |
| `right`  | `top`     | `bottom left`  | `left`  | `left`  |              |
| `right`  | `top`     | `bottom left`  | `left`  | `right` |              |
| `right`  | `top`     | `bottom left`  | `right` | `left`  |              |
| `right`  | `top`     | `bottom left`  | `right` | `right` |              |

Issues:

- [x] Keep sidebar and utilities panel open when mouse over sidebar from utilities panel (is sidebar opens when mouse over utilities panel, the sidebar should stay open when mouse over the sidebar)

Elements positions:

- Taskbar positions: `top`, `bottom`, `left`, `right`
- Dashboard positions: `left`, `right`, `top`
- Utilities positions: `top right`, `bottom right`, `top left`, `bottom left`
- Sidebar positions: `left`, `right`
- OSD (volume, brightness) positions: `left`, `right`

New settings:

- Panels > Taskbar > Position
- Panels > Dashboard > Position
- Panels > Utilities > Position
- Panels > Sidebar > Position
- "Volume & Brightness" > Position

Pull Request:

```md
Adds configurable positions for the taskbar and the panels that anchor to screen edges, so any layout can be built from the settings.

| Element                  | Positions                                              | Default        |
| ------------------------ | ------------------------------------------------------ | -------------- |
| Taskbar                  | `left`, `right`, `top`, `bottom`                       | `left`         |
| Dashboard                | `top`, `left`, `right`                                 | `top`          |
| Utilities                | `top-left`, `top-right`, `bottom-left`, `bottom-right` | `bottom-right` |
| Sidebar                  | `left`, `right`                                        | `right`        |
| OSD (volume, brightness) | `left`, `right`                                        | `right`        |

Each one can be set in the config (`bar.position`, `dashboard.position`, `utilities.position`, `sidebar.position`, `osd.position`) or in the settings app under Panels > Taskbar / Dashboard / Utilities / Sidebar and "Volume & Brightness" > Position.

### How it works

Edge insets, hit-testing and drag direction are centralised in a new `EdgeGeometry` component, which `ContentWindow`, `Panels`, `Regions`, `Interactions` and `Exclusions` now use instead of assuming a left bar. Bar components lay out along a single `horizontal` axis, and `LazyListView` gained a horizontal orientation for the workspaces.

If a panel is configured on the same edge as the bar, it opens from another edge instead, since its hover zone would otherwise sit under the bar and could never be reached.

### Breaking changes

None with default settings, the layout is identical to before.

### Testing

- Every combination of panel positions was tested
- `qmlformat`, `scripts/qml-lint-conventions.py` and `qmllint`

### Screenshots

(to add)
```

Fixes:

- Taskbar clock alignment when taskbar is vertical
