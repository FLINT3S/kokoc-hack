import {Division} from "@data/types/division.ts";

export type Employee = {
  id: number
  name: string
  surname: string,
  division: Omit<Division, 'employees'>,
  requestedAt: string
}