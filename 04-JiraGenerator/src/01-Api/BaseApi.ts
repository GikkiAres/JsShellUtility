export async function getRequest(url: string) {
  // const dto: WebsiteDto.FindAll = {
  //   userId: 0,
  //   projectId: 0
  // }
  // const reqBody = JSON.stringify(dto);
  // console.log(`reqBody:${reqBody}`);
  const res = await fetch(url, {
    method: "GET",
    headers: { "Content-Type": "application/json" },
    body: undefined
  });
  const result = await res.json() as [];
  // const models = plainToInstance(WebsiteModel, result);
  console.log(result);
  return result;
}