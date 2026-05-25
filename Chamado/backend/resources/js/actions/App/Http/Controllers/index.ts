import Api from './Api'
import DashboardController from './DashboardController'
import ChamadoController from './ChamadoController'
import BudgetController from './BudgetController'
import MaterialController from './MaterialController'
import ReportController from './ReportController'
import Settings from './Settings'
const Controllers = {
    Api: Object.assign(Api, Api),
DashboardController: Object.assign(DashboardController, DashboardController),
ChamadoController: Object.assign(ChamadoController, ChamadoController),
BudgetController: Object.assign(BudgetController, BudgetController),
MaterialController: Object.assign(MaterialController, MaterialController),
ReportController: Object.assign(ReportController, ReportController),
Settings: Object.assign(Settings, Settings),
}

export default Controllers