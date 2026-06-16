import AuthController from './AuthController'
import ProfileController from './ProfileController'
import ChamadoController from './ChamadoController'
import DashboardController from './DashboardController'
import MaterialController from './MaterialController'
import BudgetController from './BudgetController'
import ReportController from './ReportController'

const Api = {
    AuthController: Object.assign(AuthController, AuthController),
    ProfileController: Object.assign(ProfileController, ProfileController),
    ChamadoController: Object.assign(ChamadoController, ChamadoController),
    DashboardController: Object.assign(DashboardController, DashboardController),
    MaterialController: Object.assign(MaterialController, MaterialController),
    BudgetController: Object.assign(BudgetController, BudgetController),
    ReportController: Object.assign(ReportController, ReportController),
}

export default Api