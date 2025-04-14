import { getRequest } from "./BaseApi";

export class Api {
  transition() {

  }

  async getState() {
    const key = `HMOS-1944`;
    const url = `http://jira.mailtech.cn/rest/api/2/issue/${key}?fields=status`
    const req = await getRequest(url);
  }
}

export const api = new Api();