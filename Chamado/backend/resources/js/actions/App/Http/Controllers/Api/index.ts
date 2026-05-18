import AuthController from './AuthController'
import ChamadoController from './ChamadoController'
const Api = {
    AuthController: Object.assign(AuthController, AuthController),
ChamadoController: Object.assign(ChamadoController, ChamadoController),
}

export default Api