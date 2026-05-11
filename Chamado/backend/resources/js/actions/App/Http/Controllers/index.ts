import Api from './Api'
import DashboardController from './DashboardController'
import ChamadoController from './ChamadoController'
import Settings from './Settings'
const Controllers = {
    Api: Object.assign(Api, Api),
DashboardController: Object.assign(DashboardController, DashboardController),
ChamadoController: Object.assign(ChamadoController, ChamadoController),
Settings: Object.assign(Settings, Settings),
}

export default Controllers